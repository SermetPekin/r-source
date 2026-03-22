echo "sym1" > g.tmp
echo "sym2" >> g.tmp
echo " sym3" >> g.tmp
echo "hide1" > ga.hide
echo "sym2" >> ga.hide
python3 -c "h=set(x.strip() for x in open('ga.hide')); open('out.def','w',newline='\n').write('\n'.join(['LIBRARY dummy.dll', 'EXPORTS'] + [x.strip() for x in open('g.tmp') if x.strip() and x.strip() not in h and not x.startswith('.')]) + '\n')"
cat out.def
