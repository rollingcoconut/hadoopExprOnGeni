#! /usr/bin/env python

import sys, string, os
from pydictionarySpliceKey import gutDict 
# #######################################
#  parseOutputMP.py
#  GENI HADOOP MOOC PROJECT 
#  replace filename with bookname
#  scriptUsage: {./scriptname freq, filename}
#  ==> output is : { bookname, freq, url(optional)}  
# #######################################


def main():
        # Open python dictionary containing (k,v) -> (filename, bookname)
        #f = open('/home/hadoop/pydictionarySpliceKey','r')
        #gutDict = eval(f.read())

        # For highly correlated books 
        for line in sys.stdin:
		try:
	                freq, words = line.split()
	                filename = list(words)
	                isurl = False 
	                lsfilename = filename[:]
	
	                # IF filename has C or other end mark remove it and confirm that bookname is digits
	                # If filename contains nondigits, URL will not be generated
	                if not lsfilename[-1].isdigit():
	                        lsfilename=filename[0:-1]
	                else:
	                        isurl = True
	
	                # Reconsitute filename
	                filename = ''.join(lsfilename)
	
	
	                # Try to insert v for (k,v) pair
	                try:
	                        if filename in gutDict:
	                                bookname= gutDict[filename]
	                except:
	                        pass
	
	                # Constitute url if isurl
	                if isurl:
	                        url = ''.join(["http://www.gutenberg.org/ebooks/",filename])
	
	                # print bookname
	                check=list(bookname)
	                # remove charcaters in brackets after filename
	                if '[' in check: 
	                        for i in [i for i, x in enumerate(check) if x == '[']:
	                                check = check[0:i-1]
	                                check = ''.join(check) 
	                                if isurl:
	                                        print '%s\t%s\t%s' % (check, freq, url)
	                                else:
	                                        print '%s\t%s' % (check, freq) 
	                else:
	                                if isurl:
	                                        print '%s\t%s\t%s' % (bookname, freq, url)
	                                else:
	                                        print '%s\t%s' % (bookname, freq) 
		except: continue	

if __name__ == "__main__":
        main()
