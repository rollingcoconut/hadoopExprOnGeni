#! /usr/bin/env python

########################################
# reducerEXPR.py 
# GENI HADOOP MOOC 
# MAPPER INPUT => (filename, wc, count, groupPos)
# REDUCER OUTPUT => (fileid, relevance score)
# ALGORITHM EMPLOYED IS FREQUENCY
########################################

from __future__ import division
from itertools import groupby
from operator import itemgetter
import sys, string, os


def read_mapper_output(file, separator='\t'):
        for line in file:
		line = line.replace('.', '\t')
                yield line.strip().split(separator)

#CALCULATE term frequency per book
def avg(wc,count):
        wc = int(wc)
        return  count/(wc/105.00)

#AVERAGE for number of interests passed
def avg2(llist):
        llist = list(llist)
        s = sum(llist)
        i = 0
        for  x in llist: i = i+1
        return s/i


def main():
	data = read_mapper_output(sys.stdin, separator='\t')
	for filename, group in groupby(data, itemgetter(0)):
		try:
			total_count= avg2( (avg(int(wc),int(count))) for filename, wc, count in group )
                	print '%.10f\t%s' % (total_count, filename) 
		except ValueError: pass

if __name__ == "__main__":
        main()
