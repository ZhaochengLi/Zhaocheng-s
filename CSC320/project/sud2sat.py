import sys
import os
import math
import shutil

'''
BLUEPRINT:
    1. Read file for puzzle and load it into a sequence of numbers and symbols
    2. convert it inro CNF format
    3. make it pass minisat command and save the output
'''
def toDecimal(i, j, k, row):
    return (row**2)*(i-1)+row*(j-1)+k

def constraint01(output, row, fil):
    for i in range(1,row+1):
        for j in range(1,row+1):
            list = ""
            if int(output[i-1][j-1]) not in range(1,row+1):
                for k in range(1, row+1):
                    list += "%s "%(toDecimal(i,j,k,row))
            else:
                list = "%s "%(toDecimal(i,j,int(output[i-1][j-1]),row))
            fil.write("%s%s\n"%(list,0))

    return 0

def constraint02(output,row,fil):
    for i in range(1,row+1):
        for k in range(1,row+1):
            for j in range(1,row):
                for l in range(j+1,row+1):
                    fil.write("-%s -%s 0\n"%(toDecimal(j,i,k,row),toDecimal(l,i,k,row)))

    return 0

def constraint03(output,row,fil):
    for j in range(1,row+1):
        for k in range(1,row+1):
            for i in range(1,row):
                for l in range(i+1,row+1):
                    fil.write("-%s -%s 0\n"%(toDecimal(j,i,k,row),toDecimal(j,l,k,row)))

    return 0

def constraint04(output,row,fil):
    ma=int(math.sqrt(row))
    for k in range(1,row+1):
        for a in range(0,ma):
            for b in range(0,ma):
                for u in range(1,ma+1):
                    for v in range(1,ma+1):
                        for w in range(v+1,ma+1):
                            fil.write("-%s -%s 0\n"%(toDecimal((ma*a+u),(ma*b+v),k,row),toDecimal((ma*a+u),(ma*b+w),k,row)))
                        for w in range(u+1,ma+1):
                            for t in range(1,ma+1):
                                fil.write("-%s -%s 0\n"%(toDecimal((ma*a+u),(ma*b+v),k,row),toDecimal((ma*a+w),(ma*b+t),k,row)))

    return 0

def constraint05(output,row,fil):
    for i in range(1,row+1):
        for j in range(1,row+1):
            for k in range(1,row):
                for t in range(k+1,row+1):
                    fil.write("-%s -%s 0\n"%(toDecimal(i,j,k,row),toDecimal(i,j,t,row)))

    return 0

def constraint06(output,row,fil):
    for i in range(1,row+1):
        for j in range(1,row+1):
            temp=""
            appear=True
            for k in range(1,row+1):
                if appear==False:
                    temp+=""
                appear=False
                temp+="%s "%(toDecimal(k,i,j,row))
            fil.write("%s0\n"%temp)

    return 0

def constraint07(output,row,fil):
    for i in range(1,row+1):
        for j in range(1,row+1):
            temp=""
            appear=True
            for k in range(1,row+1):
                if appear==False:
                    temp+=""
                appear=False
                temp+="%s " %(toDecimal(i,k,j,row))
            fil.write("%s0\n"%temp)

    return 0

def constraint08(output,row,fil):
    ma=int(math.sqrt(row))
    for i in range(1,row+1):
		for j in range(0,ma):
			for k in range(0,ma):
				temp = ""
				first = True
				for l in range(1,ma+1):
					for t in range(1,ma+1):
						if first == False:
							temp += ""
						first = False
						temp += "%s " %(toDecimal(ma*j+l,ma*k+t,i,row))
				fil.write("%s%s\n" %(temp,0))
    return 0

def CNF_processing(output,row,fil,magic):
    var_num=row*row*row
    if magic==False:
        clause_num=(row*row*int(math.sqrt(row))*int(math.factorial(row)/math.factorial(2)/math.factorial(row-2)))+(row*row)
    elif magic==True:
        clause_num= (row*row*(int(math.sqrt(row))+1)*int(math.factorial(row)/math.factorial(2)/math.factorial(row-2))) + (row*row*(int(math.sqrt(row))+1))
    fil.write("p cnf %s %s\n"%(var_num, clause_num))

#=====================Mininal Encoding=================================
    #each element contains at least oen number
    constraint01(output,row,fil)
    #each row contains at most one of each number
    constraint02(output,row,fil)
    #each column contains at most one of each number
    constraint03(output,row,fil)
    #each number apperas ar most once per grid
    constraint04(output,row,fil)

#======================Extened Encoding================================
    if magic==True:
        #at most one number in each entry
        constraint05(output,row,fil)
        #Each number appears at least once in each row
        constraint06(output,row,fil)
        #Each number appears at least once in each column
        constraint07(output,row,fil)
        #Each number appears at least once in each sub-grid
        constraint08(output,row,fil)

    fil.close()
    return 0

def magic_input(x):
    dict=[]
    temp=[]
    grid=[]
    for i in range(1,int(math.sqrt(len(x)))+1):
        dict.append(str(i))
    for i in x:
        if i not in dict:
            temp.append('0')
        else:
            temp.append(i)
    new_x="".join(temp)
    #print(new_x)
    for i in range(0, len(x), int(math.sqrt(len(x)))):
		grid.append(new_x[i:i+int(math.sqrt(len(x)))])
    return grid

def main():

    '1.1 detect arguemnts'

    input = ""
    folder = ""
    if len(sys.argv) == 1:
        #print("Argument failure: No input (output optional)")
        sys.exit("Argument failure: No Input (Output Optional)")
    if len(sys.argv) > 2:
        sys.exit("Argument failure: Two Arguments at Most")

    try:
        file = open(sys.argv[1])
        input = file.read()
        file.close()
    except:
        sys.exit("Not A TEXT File")
#=======================
    if sys.argv[1]=="p096_sudoku.txt":
        res="Grid_CNF"
        dir=os.getcwd() + "/" + res
        if not os.path.exists(dir):
            print("Making a new folder ...")
            os.makedirs(res)
        else:
            print("Folder exists. Overwrite")
            shutil.rmtree(dir)
            os.makedirs(res)
    elif sys.argv[1]=="top95.txt":
        res="Grid_CNF_extended"
        dir=os.getcwd() + "/" + res
        if not os.path.exists(dir):
            print("Making a new folder ...")
            os.makedirs(res)
        else:
            print("Folder exists. Overwrite")
            shutil.rmtree(dir)
            os.makedirs(res)
    elif sys.argv[1]=="4x4grid.txt":
        res="Grid_CNF4x4"
        dir=os.getcwd() + "/" + res
        if not os.path.exists(dir):
            print("Making a new folder ...")
            os.makedirs(res)
        else:
            print("Folder exists. Overwrite")
            shutil.rmtree(dir)
            os.makedirs(res)
    #res01="Grid_CNF"
    #res02="Grid_CNF_extended"
    #dir01 = os.getcwd() + "/" + res01
    #dir02 = os.getcwd() + "/" + res02

    #os.chdir(dir)

    '1.2 file process (line by line)'
    title="Grid_CNF"
    output = []
    magic=True
    num=0
    row=0
    #detect if we are in the same 'Grid' still
    check=1
    first_grid=True
    for i in input.splitlines():
        if i.startswith("Grid"):
            os.chdir(dir)
            magic=False
            if first_grid is False:
                CNF_processing(output,row,fil,magic)
                #reset
                output=[]
            first_grid=False
            num += 1
            fil_name = title + str(num).zfill(2) + ".txt"
            if check != num:
                row = 0
                check += 1
                fil.close()
            fil=open(fil_name,"w")

        elif not i.startswith("Grid") and magic==False:
            #it you open and write a file repeatedly, the content will be over-written
            row += 1
            output.append(i)
        elif magic==True and i!='\x1a':
            os.chdir(dir)
            #make lines readable
            row+=1
            output=magic_input(i)
            fil_name = title+str(row).zfill(2)+"_hard.txt"
            fil=open(fil_name,"w")
            col=len(output)
            CNF_processing(output,col,fil,magic)

    if output!=[] and magic is False:
        CNF_processing(output,row,fil,magic)


    fil.close()

    '1.3(optional), execute minisat and convert them into another folder'
    grid_cnf=os.listdir(os.getcwd())
    #make another folder to contain the output from minisat
    print("minimal SAT processing ... ...")
    for cnf_txt in grid_cnf:
        resq=""
        try:
            newname="Satenc_"+cnf_txt
            if magic==False:
                resq=res
                if res=="Grid_CNF":
                    newfile="../miniSAT_encoded"
                elif res=="Grid_CNF4x4":
                    newfile="../miniSAT_encoded4x4"
            elif magic==True:
                resq=res
                newfile="../miniSAT_hard_encoded"
            if not os.path.exists(newfile):
                os.makedirs(newfile)
            os.chdir(newfile)
            command="minisat "+"../"+resq+"/"+cnf_txt+" "+newname
            os.system(command)
        except:
            sys.exit(cnf_txt+" NOT FOUND")

    return 0

if __name__ == "__main__":
    main()
