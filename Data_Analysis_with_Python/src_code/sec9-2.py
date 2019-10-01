'''
TASK: CREATE A SCRIPT THAT COUNTS THE WORDS IN ITS INPUT AND WRITES OUT THE MOST       COMMON ONES
'''

import sys
from collections import Counter



# pass in number of words as first argument

try:
    num_words = int(sys.argv[1])

except:
    print("Error")
    sys.exit(1)
    
    # non-zero exit code indicates ERROR!!!

counter = Counter(word.lower()                     # lowercase words
                  for line in sys.stdin 
                  for word in line.strip().split() # split on spaces
                  if word)                         # skip empty "words"


# notice, ".strip([chars])", it is used to return a copy of the
# string in which all chars have been stripped from the beginning and the
# end of the string (default white space characters). 
# chars -- the characters to be removed from beginning or end of the string.


for word, count in counter.most_common(num_words):
    sys.stdout.write(str(count))
    sys.stdout.write("\t")
    sys.stdout.write(word)
    sys.stdout.write("\n")
