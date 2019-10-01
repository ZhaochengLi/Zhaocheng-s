import sys, re
from collections import Counter


# sys.argv is the list of command-line arguments
# sys.argv[0] is the name of the program itself
# sys.argv[1] will be the regex specified at the command line

regex = sys.argv[1]

count = 0

# for every line passed into the script

for line in sys.stdin:
    count += 1    


    # if it matches the regex, write it to stdout
    
    if re.search(regex, line):
        # sys.stdout.write(line) or 
        print(count)
        print(line)	
        sys.exit(0)


'''
DESCRIPTION:
===========

======
TASK 1: SIMPLE INPUT & OUTPUT
======

======
TASK 2: COUNT THE INPUT LINES
======
'''
