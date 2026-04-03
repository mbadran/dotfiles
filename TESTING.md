# Testing Guide

Verification checklists for dotfiles changes. The goal is not to break the shell.

## Before Any Commit

- [ ] `git diff --stat` -- review what's changing
- [ ] `git diff` -- read the actual diff for anything unexpected

## Starship

### Powerline glyphs (CRITICAL — check after every edit)

The `format` and `right_format` blocks in `starship.toml` contain powerline
Private Use Area glyphs that some text tools silently strip:

There are four distinct glyphs — two chevrons and two rounded caps:

- U+E0B6 — left half-circle (rounded left cap of left prompt)
- U+E0B0 — right chevron (transitions between left prompt segments)
- U+E0B2 — left chevron (transitions between right prompt segments)
- U+E0B4 — right half-circle (rounded right cap of right prompt)

**After any edit to starship.toml, run this before committing:**

```sh
python3 -c "
c = open('.config/starship.toml').read()
counts = {
    'U+E0B6 (left round cap)':  c.count('\ue0b6'),
    'U+E0B0 (right chevron)':   c.count('\ue0b0'),
    'U+E0B2 (left chevron)':    c.count('\ue0b2'),
    'U+E0B4 (right round cap)': c.count('\ue0b4'),
}
for k, v in counts.items(): print(f'{k}: {v}')
ok = (counts['U+E0B6 (left round cap)'] == 2
  and counts['U+E0B0 (right chevron)']  == 4
  and counts['U+E0B2 (left chevron)']   == 8
  and counts['U+E0B4 (right round cap)'] == 2)
print('PASS' if ok else 'FAIL — expected 2/4/8/2')
"
```

Expected: **2 left round caps**, **4 right chevrons**, **8 left chevrons**, **2 right round caps**.
Both prompts are pill-shaped: round caps on both ends, chevrons between segments.
If any count is wrong, the pills/chevrons/rounded ends will be broken or missing.

**Known causes of stripping:**
- Claude Code's Write and Edit tools drop U+E000–U+F8FF (basic PUA range)
- Some editors normalise or strip PUA codepoints on save
- Copy-pasting from web/docs may lose them

**How to fix if stripped** (restores all four glyph types in pill pattern):
```sh
python3 << 'FIXEOF'
# Pattern: both prompts are pill-shaped
# round-L at start, chevrons between segments, round-R at end
content = open('.config/starship.toml').read()
lines = content.split('\n')
in_left = in_right = False
left_first = left_last_idx = None
right_first = right_last_idx = None
result = []
for i, line in enumerate(lines):
    if line.startswith('format = """'):
        in_left, in_right = True, False
        left_first = True
    elif line.startswith('right_format = """'):
        in_right, in_left = True, False
        right_first = True
    elif (in_left or in_right) and '"""' in line and not line.startswith(('format', 'right_format')):
        # Close: swap last bracket to round-R cap
        last = left_last_idx if in_left else right_last_idx
        if last is not None:
            for old in ['\ue0b0', '\ue0b2']:
                result[last] = result[last].replace(f'[{old}](', '[\ue0b4](', 1)
        in_left = in_right = False
    if (in_left or in_right) and '[](' in line:
        is_first = (in_left and left_first) or (in_right and right_first)
        if is_first:
            line = line.replace('[](', '[\ue0b6](', 1)  # round-L cap
            if in_left: left_first = False
            if in_right: right_first = False
        else:
            c = '\ue0b0' if in_left else '\ue0b2'       # chevron
            line = line.replace('[](', f'[{c}](', 1)
        if in_left: left_last_idx = i
        if in_right: right_last_idx = i
    result.append(line)
open('.config/starship.toml', 'w').write('\n'.join(result))
print('Restored. Run the verification script above to confirm.')
FIXEOF
```

### Visual checks

- [ ] Open a new terminal tab (don't just source -- starship caches)
- [ ] Verify **pill segments with rounded chevron transitions** between all sections
- [ ] Verify empty segments still show coloured chevrons (not hidden) — eg. `cd /tmp` to leave git context
- [ ] Verify left prompt renders: directory, git branch, git status, shell indicator
- [ ] Verify right prompt renders: time, OS icon, language versions (cd into a project)
- [ ] `starship explain` -- confirms all modules are recognised and configured
- [ ] `cd` into a git repo and check branch/status segment
- [ ] `cd` into a node/rust/python project and check language segment on right
- [ ] Check that the morse code tutor shows on the right prompt

## Zsh

- [ ] `source ~/.zshrc` in current tab -- no errors or warnings
- [ ] Open a new terminal tab -- clean startup, no errors
- [ ] Test core aliases: `ls`, `ll`, `cat`, `grep`, `find`, `top`, `vim`, `cd`, `tree`
- [ ] Test vim mode: press `Esc`, then `k`/`j` for history search
- [ ] Test `fzf`: `Ctrl-R` for history search, `Ctrl-T` for file search
- [ ] Test tab completion: type partial command + `Tab`

## Profiling

- [ ] `ZSH_PROFILE=1 zsh -i -c exit` -- should print elapsed time and log path
- [ ] `ls logs/` -- confirm a timestamped log file was created
- [ ] `cat logs/zsh-profile-*.log` -- confirm it has elapsed time + zprof output
- [ ] Normal shell (without ZSH_PROFILE) -- no profiling output, no overhead

## Git State

- [ ] `git status` -- only expected files modified/added
- [ ] No secrets or credentials staged (.env, hosts.yml, tokens, etc.)
- [ ] `git log --oneline -5` -- commit messages are descriptive
