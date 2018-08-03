import sys
import math
import time
import os

def nCr(n,r):
    f = math.factorial
    return f(n) / f(r) / f(n-r)


def returnValueAt(row, column, grid):
	return int(grid[column-1][row-1])

def convertToDecimal(x,y,z, size):
	return size**2 * (x-1) + size * (y-1)+z

def eachElementHasAtLeastOneNumber(columnNumber, outputGrid, fil):
	for x in range(1,columnNumber+1): #i
		for y in range(1,columnNumber+1): #j
			list = ""
			occurence = False
			first = True
			for z in range(1,columnNumber+1): #k
				if(returnValueAt(x,y,outputGrid) != z and occurence == False):
					#actually dont bother printing this out in that case
					if first == False:
						list += ' '
					first = False
					list += "%s" %(convertToDecimal(x,y,z, columnNumber))
				elif occurence == False:
					list = "%s" %(convertToDecimal(x,y,z, columnNumber))
					occurence = True
			#print ("%s" %list)
			#print ("%s %s" %(list,0))
			fil.write("%s %s\n" %(list,0))

def eachRowHasAtMostOneOfEachNumber(columnNumber, outputGrid, fil):
	for y in range(1,columnNumber+1): #i
		for z in range(1,columnNumber+1): #k
			for x in range(1,columnNumber): #j
				for i in range(x+1,columnNumber+1): #l
					#print ("-%s -%s" %(convertToDecimal(x,y,z, columnNumber),convertToDecimal(i,y,z, columnNumber)))
					#print ("-%s -%s 0" %(convertToDecimal(x,y,z, columnNumber),convertToDecimal(i,y,z, columnNumber)))
					fil.write("-%s -%s 0\n" %(convertToDecimal(x,y,z, columnNumber),convertToDecimal(i,y,z, columnNumber)))

def eachColumnHasAtMostOneOfEachNumber(columnNumber, outputGrid, fil):
	for x in range(1,columnNumber+1): #j
		for z in range(1,columnNumber+1): #k
			for y in range(1,columnNumber): #i
				for i in range(y+1,columnNumber+1): #l
					#print ("-%s -%s 0" %(convertToDecimal(x,y,z, columnNumber), convertToDecimal(x,i,z, columnNumber)))
					fil.write("-%s -%s 0\n" %(convertToDecimal(x,y,z, columnNumber), convertToDecimal(x,i,z, columnNumber)))

def eachNumberAppearsAtMostOncePerGrid(columnNumber, outputGrid, fil):
	for z in range(1,columnNumber+1): #k
		for i in range(0,int(math.sqrt(columnNumber))): #a
			for j in range(0,int(math.sqrt(columnNumber))): #b
				for x in range(1,int(math.sqrt(columnNumber)+1)): #u
					for y in range(1,int(math.sqrt(columnNumber)+1)): #v
						for k in range(y+1,int(math.sqrt(columnNumber)+1)): #w
							#print ("-%s -%s 0"%(convertToDecimal(int(math.sqrt(columnNumber))*i+x,int(math.sqrt(columnNumber))*j+y,z, columnNumber), convertToDecimal(int(math.sqrt(columnNumber))*i+x,int(math.sqrt(columnNumber))*j+k,z, columnNumber)))
							fil.write("-%s -%s 0\n"%(convertToDecimal(int(math.sqrt(columnNumber))*i+x,int(math.sqrt(columnNumber))*j+y,z, columnNumber), convertToDecimal(int(math.sqrt(columnNumber))*i+x,int(math.sqrt(columnNumber))*j+k,z, columnNumber)))
						for k in range(x+1,int(math.sqrt(columnNumber)+1)): #w
							for l in range(1,int(math.sqrt(columnNumber))+1): #t
								#print ("-%s -%s 0"%(convertToDecimal(int(math.sqrt(columnNumber))*i+x,int(math.sqrt(columnNumber))*j+y,z, columnNumber), convertToDecimal(int(math.sqrt(columnNumber))*i+k,int(math.sqrt(columnNumber))*j+l,z, columnNumber)))
								fil.write("-%s -%s 0\n"%(convertToDecimal(int(math.sqrt(columnNumber))*i+x,int(math.sqrt(columnNumber))*j+y,z, columnNumber), convertToDecimal(int(math.sqrt(columnNumber))*i+k,int(math.sqrt(columnNumber))*j+l,z, columnNumber)))

# -------------------

def atMostOneNumberInEachEntry(columnNumber, outputGrid, fil):
	for x in range(1,columnNumber+1):
		for y in range(1,columnNumber+1):
			for z in range(1,columnNumber):
				for i in range(z+1,columnNumber+1):
					#print ("-%s -%s 0" %(convertToDecimal(x,y,z, columnNumber), convertToDecimal(x,y,i, columnNumber)))
					fil.write("-%s -%s 0\n" %(convertToDecimal(x,y,z, columnNumber), convertToDecimal(x,y,i, columnNumber)))

def eachNumberOncePerRow(columnNumber, outputGrid, fil):
	for y in range(1,columnNumber+1):
		for z in range(1,columnNumber+1):
			list = ""
			first = True
			for x in range(1,columnNumber+1):
				if first == False:
					list += ' '
				first = False
				list += "%s" %(convertToDecimal(x,y,z, columnNumber))
			#print ("%s 0" %list)
			fil.write("%s 0\n" %list)

def eachNumberOncePerColumn(columnNumber, outputGrid, fil):
	for x in range(1,columnNumber+1):
		for z in range(1,columnNumber+1):
			list = ""
			first = True
			for y in range(1,columnNumber+1):
				if first == False:
					list += ' '
				first = False
				list += "%s" %(convertToDecimal(x,y,z, columnNumber))
			print ("%s %s" %(list,0))

def eachNumberOncePerGrid(columnNumber, outputGrid, fil):
	#print "eachNumberOncePerGrid"
	for z in range(1,columnNumber+1):
		#list = ""
		#first = True
		for i in range(0,int(math.sqrt(columnNumber))):
			for j in range(0,int(math.sqrt(columnNumber))):
				list = ""
				first = True
				for x in range(1,int(math.sqrt(columnNumber))+1):
					for y in range(1,int(math.sqrt(columnNumber))+1):
						if first == False:
							list += ' '
						first = False
						list += "%s" %(convertToDecimal(int(math.sqrt(columnNumber))*i+x,int(math.sqrt(columnNumber))*j+y,z, columnNumber))
				print ("%s %s" %(list,0))

def encodingCalls(columnNumber, outputGrid, fil):
	if(columnNumber != 0):	#not the beginning of the file
		numclause=(columnNumber*columnNumber*int(math.sqrt(columnNumber))*int(nCr(columnNumber,2))) + (columnNumber*columnNumber)
		numvar=columnNumber*columnNumber*columnNumber
		#print ("p cnf %s %s" %(numvar,numclause)) #for minimal encoding clauses
		fil.write("p cnf %s %s\n" %(numvar,numclause))

		#for extended encoding
		#exnumclause = (columnNumber*columnNumber*(int(math.sqrt(columnNumber))+1)*int(nCr(columnNumber,2))) + (columnNumber*columnNumber*(int(math.sqrt(columnNumber))+1)) #minimal + extended encodings
		#print ("p cnf %s %s" %(numvar,exnumclause))
		#fil.write("p cnf %s %s\n" %(numvar,exnumclause))

		#print "minimal encoding"
		eachElementHasAtLeastOneNumber(columnNumber, outputGrid,fil)
		eachRowHasAtMostOneOfEachNumber(columnNumber, outputGrid,fil)
		eachColumnHasAtMostOneOfEachNumber(columnNumber, outputGrid,fil)
		eachNumberAppearsAtMostOncePerGrid(columnNumber, outputGrid,fil)
		fil.close()

		'''
		#print "extended encoding"
		atMostOneNumberInEachEntry(columnNumber, outputGrid)
		eachNumberOncePerRow(columnNumber, outputGrid)
		eachNumberOncePerColumn(columnNumber, outputGrid)
		eachNumberOncePerGrid(columnNumber, outputGrid)
		'''

def hardInputToSudoku(input):
	newArr = []
	nums = []
	for i in range(1,int(math.sqrt(len(input)))+1):
		nums.append(str(i))

	for x in range(len(input)):
		if input[x] not in nums:
			newArr.append('0')
		else:
			newArr.append(input[x])

	newstr = ''.join(newArr)

	newGrid = []
	for x in range(0, len(input), int(math.sqrt(len(input)))):
		newGrid.append(newstr[x:x+int(math.sqrt(len(input)))])

	return newGrid

def main():

	if len(sys.argv) == 1:
		print "No arguments. Exiting."
		sys.exit()
	elif len(sys.argv) > 2:
		print "Enter only 1 argument. Exiting."
		sys.exit()
	else:
		inputGrid = ""
		try:
			file = open(sys.argv[1])
			inputGrid = file.read()
			file.close()
		except:
			print "Not a valid file name. Exiting."
			sys.exit()

		fldr = raw_input("What folder you like to store all the encoded Sudoku boards? Enter the folder name only. Enter a name of a folder that does not currently exist in the directory.\n")
		par_dir = os.getcwd()
		#new_dir = par_dir + "\\" + fldr #windows directory style
		new_dir = par_dir + "/" + fldr #linux directory style
		if not os.path.exists(new_dir):
			print "Making new folder " + fldr
			os.makedirs(fldr)
		else:
			print "Folder already exists. Enter another folder name. Exiting."
			sys.exit()

		os.chdir(new_dir) #will change the working directory

		columnNumber = 0
		outputGrid = []

		boolGrid = False

		'''
		#below assumes only two types of inputs,
			1. projecteuler.net/project/resources/p096 sudoku.txt
			2. magictour.free.fr/top95

		if there are other inputs, the for loop below might or might not function
		'''
		count = 1
		df = "Grid"
		for x in inputGrid.splitlines():
			if x.startswith('Grid') and boolGrid is False:
				full_fn = df + str(count).zfill(2) + ".txt"
				fil = open(full_fn,"w")
				#print x
				boolGrid = True
			elif boolGrid is True and not x.startswith('Grid'):
				outputGrid.append(x)
				columnNumber = len(outputGrid[0])
			elif boolGrid is True and x.startswith('Grid'):
				encodingCalls(columnNumber, outputGrid, fil)
				fil.close()
				count += 1
				full_fn = df + str(count).zfill(2) + ".txt"
				fil = open(full_fn,"w")
				#print x
				outputGrid = []
				columnNumber = 0
			else: #this is for all other inputs, mainly magictour (hard inputs). Not sure of other inputs
				outputGrid = hardInputToSudoku(x)
				columnNumber = len(outputGrid)
				full_fn = df + str(count).zfill(2) + ".txt"
				fil = open(full_fn,"w")
				encodingCalls(columnNumber, outputGrid, fil)
				fil.close()
				count += 1

				#reset
				outputGrid = []
				columnNumber = 0


		if outputGrid != []: #for the last grid
			encodingCalls(columnNumber, outputGrid, fil)

		fil.close()
'''
		#start of miniSAT execution
		grid_list = os.listdir(new_dir)

		#YOU MUST HAVE MINISAT WORKING ON YOUR COMMAND LINE
		for i in range(count):
			try:
				enc_out = "Grid" + str(i+1).zfill(2) + "_SATencoded.txt"
				command = "minisat " + grid_list[i] + " " + enc_out

				os.system(command)
				os.remove(grid_list[i])
			except:
				print grid_list[i] + " not found."
				print "ERROR"
				sys.exit()
'''

if __name__ == "__main__":
	main()
