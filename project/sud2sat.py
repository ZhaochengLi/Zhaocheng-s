#name: Zhaocheng Li
#id: V00832770
#CSC320 Project: Sudoku puzzle problem in SAT technique
#uvic

import sys

'''
BLUEPRINT:
    1. Read file for puzzle and load it into a sequence of numbers and symbols
    2. convert it inro CNF format
    3. make it pass minisat command and save the output
'''

#step 1: read file.
def main():
	#reading from terminal:
	if len(sys.argv) == 1:
		print("Lack of Arguments: Input and Output")
		sys.exit()
	if len(sys.argv) == 2:
		print("Lack of Arguemnts: Output file")
		sys.exit()
	if len(sys.argv) >= 3:
		print("Too much arguments")
		sys.exit()
	
	return 0
if __name__ == "__main__":
    main()
