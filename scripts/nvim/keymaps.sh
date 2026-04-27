#!/usr/bin/env bash
# Dump custom neovim keymaps to working/nvim-keymaps.md
# Parses vim.keymap.set calls marked with ♠ from init.lua.
# Run standalone or via start.sh.

unalias -a 2>/dev/null || true
set -euo pipefail
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO"

python3 - <<'PYEOF'
import re
from collections import OrderedDict

INIT_LUA = ".config/nvim/init.lua"
OUT      = "working/nvim-keymaps.md"

SECTION_RE = re.compile(r'^--- ♠ (.+?) -+\s*$')
DESC_RE    = re.compile(r'desc\s*=\s*"♠\s*(.+?)"')
MODE_KEY_RE= re.compile(r'vim\.keymap\.set\(\s*"([^"]+)"\s*,\s*"([^"]+)"')
MODE_NAMES = {'n': 'normal', 'v': 'visual', 'i': 'insert', 'x': 'visual block'}

def fmt_key(k):
    return k.replace('<leader>', 'SPC ')

with open(INIT_LUA) as f:
    raw = f.readlines()

sections = OrderedDict()
current  = None
i, n     = 0, len(raw)

while i < n:
    line = raw[i].rstrip()

    m = SECTION_RE.match(line)
    if m:
        current = m.group(1).strip()
        sections.setdefault(current, [])
        i += 1
        continue

    if current and 'vim.keymap.set(' in line:
        call  = line
        depth = line.count('(') - line.count(')')
        j     = i + 1
        while depth > 0 and j < n:
            call  += '\n' + raw[j].rstrip()
            depth += raw[j].count('(') - raw[j].count(')')
            j     += 1

        if '♠' in call:
            mk = MODE_KEY_RE.search(call)
            dm = DESC_RE.search(call)
            if mk and dm:
                mode = MODE_NAMES.get(mk.group(1), mk.group(1))
                key  = fmt_key(mk.group(2))
                desc = dm.group(1).strip()
                sections[current].append((mode, key, desc))
        i = j
        continue

    i += 1

# compute column widths
all_rows = [(m, k, d) for s in sections.values() for m, k, d in s]
w_mode = max(len('mode'),   max(len(m) for m, _, __ in all_rows))
w_key  = max(len('key'),    max(len(k)+2 for _, k, __ in all_rows))  # +2 for backticks
w_desc = max(len('description'), max(len(d) for _, __, d in all_rows))

def row(mode, key, desc):
    key_cell = f'`{key}`'
    return f'| {mode:<{w_mode}} | {key_cell:<{w_key}} | {desc:<{w_desc}} |'

def sep():
    return f'|-{"-"*w_mode}-|-{"-"*w_key}-|-{"-"*w_desc}-|'

hdr = f'| {"mode":<{w_mode}} | {"key":<{w_key}} | {"description":<{w_desc}} |'

out = [
    '# Neovim keymaps',
    '',
    '> Leader: `SPC` (space bar)  ·  Source: `.config/nvim/init.lua`',
    '',
]

for section, items in sections.items():
    out += [f'## {section}', '', hdr, sep()]
    for mode, key, desc in items:
        out.append(row(mode, key, desc))
    out.append('')

with open(OUT, 'w') as f:
    f.write('\n'.join(out) + '\n')

total = sum(len(v) for v in sections.values())
print(f'wrote {OUT}  ({total} mappings across {len(sections)} sections)')
PYEOF
