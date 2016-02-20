#! /usr/bin/env python

import sys, string, os
from sys import argv
import collections

########################################
# testInput.py
# GENI HADOOP MOOC PROJECT SEPT 4 
# tests input for punctuation, case, factorIsNo
########################################

def isFloat(string):
    try:
        float(string)
        return True
    except ValueError:
        return False

def main():
        #scriptname ignored
        sys.argv2 = sys.argv[2:]

        # input parsed of punctutaion, and convered to lower()
        y = [(x.strip().lower().translate(None, string.punctuation)) for x in sys.argv]
        y = y[2:]

        # if input affected by last operation exit with return 1
        if not set(sys.argv2) == set(y): exit(1)

        # make sure sys.argv[1] is a digit
        #isFactorNo = str.isdigit(sys.argv[1]) or isFloat(sys.argv[1]) 
        isFactorNo = str.isdigit(sys.argv[1]) 
        if not  isFactorNo: exit(1)

if __name__ == "__main__":
        main()
