python -c "
with open('out2.def', 'wb') as f:
    f.write(b'LIBRARY dummy.dll\nEXPORTS\n')
    for x in open('g.tmp', 'rb'):
        s = x.strip()
        if s and not s.startswith(b'.') and s not in [b'sym2']:
            f.write(s + b'\n')
"
cat out2.def
