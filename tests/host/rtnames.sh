#!/bin/sh
# rtnames.sh -- the compiler's table of runtime external names
# (backend/s370_rtnames.h) and the runtime's asm labels (runtime/s370/
# f77rt.h) must agree: a name the compiler emits that the runtime does
# not export is an unresolved external at link time, on MVS.
cd "$(dirname "$0")/../.."
python3 - <<'EOF'
import re, sys
tab = open('backend/s370_rtnames.h').read()
m = re.search(r'static char \*s370_rt_map\[\] = \{(.*?)\n    0 \};', tab, re.S)
comp = dict(re.findall(r'"([^"]+)",\s*"([^"]+)"', m.group(1)))
rt = dict(re.findall(r'(f77i?_\w+)\([^)]*\)\s*__asm__\("([^"]+)"\)', open('runtime/s370/f77rt.h').read()))
bad = 0
for c, e in comp.items():
    if c.startswith('f77_'):
        if c not in rt: print('runtime lacks', c, e); bad += 1
        elif rt[c] != e: print('name differs', c, e, rt[c]); bad += 1
for c, e in rt.items():
    if c.startswith('f77_') and c not in comp and c not in ('f77_dint', 'f77_dnint'):
        print('compiler table lacks', c, e); bad += 1
    if len(e) > 8: print('too long', c, e); bad += 1
dup = {}
for c, e in rt.items(): dup.setdefault(e, []).append(c)
for e, cs in dup.items():
    if len(cs) > 1: print('duplicate external', e, cs); bad += 1
print('rtnames:', 'ok' if not bad else '%d problem(s)' % bad)
sys.exit(1 if bad else 0)
EOF
