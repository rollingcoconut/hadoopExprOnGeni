#! /usr/bin/env python

########################################
# mapper.py
# GENI HADOOP MOOC 
# MAPPER INPUT => [word.bookid.wc count]
# MAPPER OUTPUT => [bookid wc count]
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
	"""**A Note on Technique:*
	Iterating through the sys.argv array while simultaneously reading the gutenberg doc file is a logical way 
	to avoid the redundancy of 2 for loops. However, this technique acted weirdly here, I believe due 
	to state required by the iterator. Therefore the 'is word in sys.argv' method was used"""

	data = read_input(sys.stdin)   					#GET LINE FROM GENERATOR
													#NORMALIZED RELEVEANT USER SEARCH TERMS 
	searchFor= sorted([stemAndCtrlRemove(term) for term in sys.argv[2:]]) 
	for current_word, group in groupby(data, itemgetter(0)):	#GROUP DATA TO LESSEN LINE CHECKS
		if current_word in searchFor:
			for i in (c for w,c in group):			#PRINT GROUP THAT MATCHES A SYS.ARGV ENTRY
				try: 
					print  str(i).replace('.',"\t")
				except: continue
			
if __name__ == "__main__":
	main()
