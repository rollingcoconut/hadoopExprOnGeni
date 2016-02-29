#! /usr/bin/env python

########################################
# reducerEXPR.py 
# GENI HADOOP MOOC 
# MAPPER INPUT => (filename, wc, count)
# REDUCER OUTPUT => (fileid, relevance score)
# *algorithm employed is frequency*
########################################

from __future__ import division
from itertools import groupby
from operator import itemgetter
import sys, string, os
from sys import argv

def read_mapper_output(file, separator='\t'):
        for line in file:
                yield line.strip().split(separator)

#CALCULATE term frequency per book
def avg(wc,count):
        return  count/(wc/105.00)

#AVERAGE for number of interests passed
"""*Fix for both words not being represented*
The FIX: 
		The books whose return are prioritized must contain moderate frequences of all instances of the stemmed word.
		Books with a high frequency  for only particular words receive a penalty to their relevance score.
"""

def avg2(llist):
	noArgs= int(sys.argv[1]) -1 	
       	s = sum(llist)						#THE COLLECTIVE SUM OF FREQUENCIES FOR A BOOK
	if noArgs == len(llist): return s/noArgs	#DOES THE BOOK HAVE INSTANCES OF ALL SEARCH TERMS
        else:  return s/(100*noArgs)			#IF NOT PENALIZE IT


def main():
	data = read_mapper_output(sys.stdin, separator='\t')
	for filename, group in groupby(data, itemgetter(0)): 	#GROUP BY BOOK IDS
		try:
			#WRAPPER FUNCTION AVERAGES THE per-word-freq FOUND IN INNER FUNCTION
			total_count= avg2([ (avg(int(wc),int(count))) for filename, wc, count in group ])
                	print '%.10f\t%s' % (total_count, filename) 
		except ValueError: pass

if __name__ == "__main__":
        main()
