#! /usr/bin/env python

########################################
# Feb 29
# showNorm.py
# GENI HADOOP MOOC 
# Purpose of Script: ==> Let user see what their search terms become when stemmed
########################################

#THE DATA HAS BEEN STEMMED, THEREFORE THE USER INPUT SHOULD ALSO BE STEMMED AND NATRUAL LANG PACKAGES HAVE BEEN IMPORTED 
import sys, string, os, zipimport,unicodedata
from sys import argv
importer = zipimport.zipimporter('AUX_FILES/nltk.mod')
nltk = importer.load_module('nltk')

#NORMALIZE AND STEM USER INPUT
def stemAndCtrlRemove(s):
	stemmer = nltk.stem.SnowballStemmer("english")
	s =stemmer.stem(s.lower().translate(None,string.punctuation))
	return s


def main():
	searchFor= sorted([stemAndCtrlRemove(term) for term in sys.argv[2:]]) 
	print searchFor
			
if __name__ == "__main__":
	main()
