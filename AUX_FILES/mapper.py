#! /usr/bin/env python

########################################
# mapper.py
# GENI HADOOP MOOC 
# MAPPER OUTPUT => (lines in data whose first entry matches user interst) 
########################################

#THE DATA HAS BEEN STEMMED, THEREFORE THE USER INPUT SHOULD ALSO BE STEMMED AND NATRUAL LANG PACKAGES HAVE BEEN IMPORTED 
import sys, string, os, zipimport,unicodedata
from sys import argv
from bisect import bisect_left
from itertools import groupby
from operator import itemgetter
importer = zipimport.zipimporter('nltk.mod')
nltk = importer.load_module('nltk')

#NORMALIZE AND STEM USER INPUT
def stemAndCtrlRemove(s):
	stemmer = nltk.stem.SnowballStemmer("english")
	s =stemmer.stem(s.lower().translate(None,string.punctuation))
	return s

#GENERATOR TO READ FILE
def read_input(file):
	for line in file: yield line.rstrip().split('.', 1)

def main():
	data = read_input(sys.stdin)   					#GET LINE FROM GENERATOR
	newSysArgv = [stemAndCtrlRemove(term) for term in sys.argv] 	#NORMALIZE USER INPUT
	searchFor = [x for i, x in enumerate(newSysArgv)]
	count = 1							#ITERATE THROUGH SYS.ARGV
	currW = searchFor[count]
	for current_word, group in groupby(data, itemgetter(0)):	#GROUP DATA TO LESSEN LINE CHECKS
		try:
			if (current_word == currW):
				for i in (c for w,c in group):		#PRINT GROUP THAT MATCHES A SYS.ARGV ENTRY
					try: print str(i)
					except: continue
			currW = searchFor[count + 1]
		except: continue
			
if __name__ == "__main__":
	main()
