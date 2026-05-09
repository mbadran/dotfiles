#!/usr/bin/env python3
"""Sync Brewfile with installed brew/cask state.

Forward drift: installed manually but not tracked → append to Brewfile
                under an 'uncategorized' section, with the brew-info description.
Reverse drift: tracked but not installed → remove from Brewfile, but only
                for packages that were confirmed installed in a prior run
                (state file gates this so a fresh-clone machine doesn't get
                its Brewfile wiped before bundle install runs).

The state file (`.config/brew/.installed.lock`) is host-local (gitignored)
and just records the last-seen installed set.

Lines that are commented out (e.g. `# cask "ovim"`) are treated as a
deliberate exclusion — neither auto-removed nor re-added if installed.
"""

import json
import re
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
BREWFILE = REPO / ".config/brew/Brewfile"
STATE_FILE = REPO / ".config/brew/.installed.lock"
UNCATEGORIZED_HEADER = (
    "# ------------------------------------------------------ uncategorized ♠ ---"
)


def sh(cmd):
    out = subprocess.check_output(cmd, stderr=subprocess.DEVNULL).decode().strip()
    return [x for x in out.split("\n") if x]


def get_descs(names, is_cask):
    """Batched description lookup. Returns {name: desc}."""
    if not names:
        return {}
    flag = "--cask" if is_cask else "--formula"
    try:
        raw = subprocess.check_output(
            ["brew", "info", "--json=v2", flag, *names],
            stderr=subprocess.DEVNULL,
        ).decode()
        data = json.loads(raw)
    except (subprocess.CalledProcessError, json.JSONDecodeError):
        return {n: "" for n in names}
    items = data.get("casks" if is_cask else "formulae", [])
    out = {}
    for item in items:
        # casks key on `token`/`full_token`, formulae on `name`/`full_name`
        keys = (
            (item.get("token"), item.get("full_token"))
            if is_cask
            else (item.get("name"), item.get("full_name"))
        )
        for k in keys:
            if k:
                out[k] = item.get("desc", "") or ""
    return {n: out.get(n, "") for n in names}


def parse(text):
    """Return active sets and the set of names that have a commented-out entry."""
    active_brew, active_cask, active_tap = set(), set(), set()
    commented_brew, commented_cask = set(), set()
    for line in text.splitlines():
        m = re.match(r'^\s*brew\s+"([^"]+)"', line)
        if m:
            active_brew.add(m.group(1))
            continue
        m = re.match(r'^\s*cask\s+"([^"]+)"', line)
        if m:
            active_cask.add(m.group(1))
            continue
        m = re.match(r'^\s*tap\s+"([^"]+)"', line)
        if m:
            active_tap.add(m.group(1))
            continue
        m = re.match(r'^\s*#\s*brew\s+"([^"]+)"', line)
        if m:
            commented_brew.add(m.group(1))
            continue
        m = re.match(r'^\s*#\s*cask\s+"([^"]+)"', line)
        if m:
            commented_cask.add(m.group(1))
    return active_brew, active_cask, active_tap, commented_brew, commented_cask


def remove_lines(text, names, kind):
    pattern = re.compile(rf'^\s*{kind}\s+"([^"]+)"')
    out = []
    for line in text.splitlines():
        m = pattern.match(line)
        if m and m.group(1) in names:
            continue
        out.append(line)
    return "\n".join(out) + "\n"


def insert_taps(text, taps):
    """Insert tap lines after the last existing tap line (or at the top of taps section)."""
    if not taps:
        return text
    lines = text.splitlines()
    last_tap_idx = -1
    for i, line in enumerate(lines):
        if re.match(r'^\s*tap\s+"', line):
            last_tap_idx = i
    new_taps = [f'tap "{t}"' for t in sorted(taps)]
    if last_tap_idx >= 0:
        lines = lines[: last_tap_idx + 1] + new_taps + lines[last_tap_idx + 1 :]
    else:
        lines = new_taps + [""] + lines
    return "\n".join(lines) + ("\n" if not text.endswith("\n") else "")


def append_uncategorized(text, items, kind):
    """Append (name, desc) items under the uncategorized section."""
    if not items:
        return text
    text = text.rstrip("\n")
    if UNCATEGORIZED_HEADER not in text:
        text += "\n\n" + UNCATEGORIZED_HEADER + "\n"
    else:
        text += "\n"
    pad = max(len(f'{kind} "{n}"') for n, _ in items) + 2
    for name, desc in items:
        prefix = f'{kind} "{name}"'
        line = f"{prefix:<{pad}}# {desc}" if desc else prefix
        text += line + "\n"
    return text


def main():
    text = BREWFILE.read_text()
    active_brew, active_cask, active_tap, comm_brew, comm_cask = parse(text)

    installed_brew = set(sh(["brew", "leaves", "--installed-on-request"]))
    installed_cask = set(sh(["brew", "list", "--cask"]))

    state = {"brew": [], "cask": []}
    if STATE_FILE.exists():
        try:
            state = json.loads(STATE_FILE.read_text())
        except json.JSONDecodeError:
            pass
    state_brew, state_cask = set(state.get("brew", [])), set(state.get("cask", []))

    # forward drift: installed but not tracked, and not commented
    add_brew = sorted((installed_brew - active_brew) - comm_brew)
    add_cask = sorted((installed_cask - active_cask) - comm_cask)

    # reverse drift: tracked but no longer installed, AND was previously seen installed
    # (the state-file gate prevents wiping the Brewfile on a fresh machine clone)
    rm_brew = sorted((active_brew - installed_brew) & state_brew)
    rm_cask = sorted((active_cask - installed_cask) & state_cask)

    # tap additions: ensure any tap-prefixed brew entry has its tap declared
    tap_prefix = lambda x: x.rsplit("/", 1)[0] if "/" in x else None
    needed_taps = {tap_prefix(x) for x in (active_brew | set(add_brew)) if "/" in x}
    needed_taps.discard(None)
    add_tap = sorted(needed_taps - active_tap)

    # informational: items installed but commented in Brewfile (deliberate exclusion)
    skipped_brew = sorted((installed_brew & comm_brew) - active_brew)
    skipped_cask = sorted((installed_cask & comm_cask) - active_cask)

    drift = bool(add_brew or add_cask or rm_brew or rm_cask or add_tap)

    if not drift and not skipped_brew and not skipped_cask:
        print("Brewfile in sync with installed state.")
    else:
        print("── brew drift sync ──")
        if rm_brew:
            print(f"  removed (formula): {', '.join(rm_brew)}")
        if rm_cask:
            print(f"  removed (cask):    {', '.join(rm_cask)}")
        if add_tap:
            print(f"  added (tap):       {', '.join(add_tap)}")
        if add_brew:
            print(f"  added (formula):   {', '.join(add_brew)}")
        if add_cask:
            print(f"  added (cask):      {', '.join(add_cask)}")
        if skipped_brew:
            print(
                f"  skipped (commented in Brewfile): {', '.join(skipped_brew)}"
            )
        if skipped_cask:
            print(
                f"  skipped (commented in Brewfile): {', '.join(skipped_cask)}"
            )

    if drift:
        if rm_brew:
            text = remove_lines(text, set(rm_brew), "brew")
        if rm_cask:
            text = remove_lines(text, set(rm_cask), "cask")
        if add_tap:
            text = insert_taps(text, add_tap)
        if add_brew:
            descs = get_descs(add_brew, is_cask=False)
            text = append_uncategorized(
                text, [(n, descs[n]) for n in add_brew], "brew"
            )
        if add_cask:
            descs = get_descs(add_cask, is_cask=True)
            text = append_uncategorized(
                text, [(n, descs[n]) for n in add_cask], "cask"
            )
        BREWFILE.write_text(text)
        print(f"  Brewfile updated — recategorise new entries from 'uncategorized' as needed.")

    # update state regardless (snapshots current reality)
    STATE_FILE.write_text(
        json.dumps(
            {"brew": sorted(installed_brew), "cask": sorted(installed_cask)},
            indent=2,
        )
        + "\n"
    )

    return 0


if __name__ == "__main__":
    sys.exit(main())
