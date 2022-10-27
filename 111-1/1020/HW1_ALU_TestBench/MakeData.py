from random import randint as rand

# ===== OPEN ===== #
A = open('./A.txt', 'w')
A_int = open('A_int.txt', 'w')
B = open('B.txt', 'w')
B_int = open('B_int.txt', 'w')
C = open('C.txt', 'w')
C_int = open('C_int.txt', 'w')
Sel = open('Sel.txt', 'w')
Alu = open('Alu_Ans.txt', 'w')
Alu_int = open('Alu_Ans_int.txt', 'w')

# ===== CLEAN ===== #
print('', end='', file=A)
print('', end='', file=A_int)
print('', end='', file=B)
print('', end='', file=B_int)
print('', end='', file=C)
print('', end='', file=C_int)
print('', end='', file=Sel)
print('', end='', file=Alu)
print('', end='', file=Alu_int)

# ===== CREATE ===== #
for i in range(0, 10000):
    # A
    a_num = rand(0, 255)
    a_new = format(a_num, '08b')
    print(a_num, file=A_int)
    print(a_new, file=A)
    # B
    b_num = rand(0, 255)
    b_new = format(b_num, '08b')
    print(b_num, file=B_int)
    print(b_new, file=B)

    # C
    c_num = rand(0, 31)
    c_new = format(c_num, '05b')
    print(c_num, file=C_int)
    print(c_new, file=C)

    # Sel
    sel = rand(0, 3)
    new = format(sel, '02b')
    print(new, file=Sel)

    if (sel == 0):
        ans = a_num + b_num
        print(ans, file=Alu_int)
        print(format(ans, '09b'), file=Alu)

    if (sel == 1):
        if (c_num % 2 == 0):
            ans = 255 - a_num
            print(ans, file=Alu_int)
            print(format(ans, '09b'), file=Alu)
        else:
            print(a_num, file=Alu_int)
            print(format(a_num, '09b'), file=Alu)
    if (sel == 3):
        if ((int(c_new[3::]) > int(a_new[6::]))):
            ans = c_num
        else:
            ans = a_num
        print(ans, file=Alu_int)
        print(format(ans, '09b'), file=Alu)
    if (sel == 2):
        if (c_num > 5):
            ans = a_num ^ b_num
            print(ans, file=Alu_int)
            print(format(ans, '09b'), file=Alu)
        else:
            ans = ""
            ans += '0'
            for i in range(0, 8):
                if (a_new[i] == b_new[i] and a_new[i] == '1' and b_new[i] == '1'):
                    ans += '0'
                else:
                    ans += '1'
            
            print(ans, file=Alu_int)
            print(ans, file=Alu)
A.close()
A_int.close()
B.close()
B_int.close()
C.close()
C_int.close()
Sel.close()
Alu.close()
Alu_int.close()
