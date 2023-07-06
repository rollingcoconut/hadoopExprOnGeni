#! /usr/bin/env python
import sys,string, os

########################################
# parseGut.py
# GENI HADOOP MOOC PROJECT SEPT 4
# create python dictioanry with (k,v) is (filename, book title)
# gutindex.all needed,  so wget it if needed ; txt in file like headers should be deleted
#script useage: { cat gutindex.all | ./scriptname } 

########################################


def main():
        d = {}
        for line in sys.stdin: 

                # line not blank space
                if not line.isspace():

                        # split gutindex.all line into list
                        words = line.strip().split()

                        # wordlist is filename number ie 33145
                        wordlist = list(words[-1])

                        # word is the filename number without the last entry, in case it is letter or *
                        word = ''.join(wordlist[0:len(wordlist)-1])

                        #if word.isdigit():
                        if word.isdigit() and words[-1].isdigit():
                                d[words[-1]] = ' '.join(words[0:len(words)-1])
                        else: 
                                d[word] = ' '.join(words[0:len(words)-1])


        f = open('/home/hadoop/pydictionarySpliceKey','w')
        f.write(str(d))

if __name__ == "__main__":
        main()
