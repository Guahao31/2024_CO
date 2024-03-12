f = open('console.out')
lines = f.readlines()
f.close()

f = open('test.s')
insts = f.readlines()
f.close()



f_out = open('ImmGen_tb_gen.txt', 'w')
for i in range(len(lines)):
    line = lines[i].strip()
    inst = insts[i].strip()
    print_str = '`LET_INST_BE(32\'h' + line[2:] + ');   //' + inst + '\n'
    f_out.write(print_str)
f_out.close()
