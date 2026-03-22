import os
def generate_def(infile, hidefile, outfile, lib_name):
    h = set(x.strip() for x in open(hidefile,'rb')) if os.path.exists(hidefile) else set()
    with open(outfile,'wb') as f:
        f.write(f'LIBRARY {lib_name}\nEXPORTS\n'.encode())
        for x in open(infile,'rb'):
            x = x.strip()
            if x and x not in h and not x.startswith(b'.'):
                f.write(b" " + x + b"\n")
print('Done script')
