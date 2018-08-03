import os
import sys
import math
'''
BLUEPRINT:
    1.read Input, check argv
    2.convertion
    3.allocation and done

'''

def sudoku_solver(output,fil):
    list=[]
    row=1
    col=0
    puzz=""
    for i in output.split():
        if int(i)>0:
            list.append(i)
    ma=math.sqrt(len(list))
    for i in list:
        if col==ma:
            col=0
            row+=1
            fil.write("%s\n"%(puzz))
            puzz=""
        col+=1
        dec=int(i)-ma*ma*(row-1)-ma*(col-1)
        puzz+="%s"%int(dec)
    fil.write("%s"%(puzz))
    fil.close()

    return 0


def main():
    '1.1 Arguments check, input as folder'
    input=[]
    folder = ""
    if len(sys.argv) == 1:
        sys.exit("Argument failure: No Input")
    if len(sys.argv) >= 3:
        sys.exit("Argument failure: Three Arguments at Most")

    if sys.argv[1] != "miniSAT_encoded" and sys.argv[1] != "miniSAT_encoded/" and sys.argv[1]!="miniSAT_hard_encoded" and sys.argv[1]!="miniSAT_hard_encoded/" and sys.argv[1]!="miniSAT_encoded4x4" and sys.argv[1]!="miniSAT_encoded4x4/":
        sys.exit("Argument Failure: Input folder 'miniSAT_encoded'")

    fold = os.getcwd()+"/"+sys.argv[1]
    os.chdir(fold)
    file=os.listdir(fold)
    for i in sorted(file):
        fi=open(i)
        input.append(fi.read())
        fi.close()

    if sys.argv[1] == "miniSAT_encoded" or sys.argv[1] == "miniSAT_encoded/":
        dir="../Sudoku_solved"
    elif sys.argv[1] == "miniSAT_encoded4x4" or sys.argv[1] == "miniSAT_encoded4x4/":
        dir="../Sudoku_solved4x4"
    elif sys.argv[1]!="miniSAT_hard_encoded" or sys.argv[1]!="miniSAT_hard_encoded/":
        dir="../Sudoku_hard_solved"

    if not os.path.exists(dir):
        print("Making a new folder ...")
        os.makedirs(dir)
    else:
        print("Warming: Folder exists. And We will Use This One")
    os.chdir(dir)

    '1.2 Read input'
    title = "Grid_solved"
    output=""
    num=0
    solve=False
    for txt in input:
        for i in txt.splitlines():
            if i.startswith("SAT"):
                solve=True
                num += 1
                fil_name = title + str(num).zfill(2) + ".txt"

                fil=open(fil_name,"w")
                #wont start another line until "\n"
                fil.write("Grid %s solved\n"%num)

            else:
                output=i
                sudoku_solver(output,fil)

    return 0

if __name__ == "__main__":
    main()
