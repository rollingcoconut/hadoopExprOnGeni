#! /bin/sh

########################################
# testInputBash
# GENI HADOOP MOOC COURSE 
# Script Useage: {./scriptname}
# ==> script will quit if input violates one of the the following:
#       1) if number of interests exceeds 5
#       2) if factorToIncreaseInputSplit is not within rage {x,y} 
# Input arguments also should not be repeated, although this is not tested
########################################


#EXIT if interests exceed 5
if [ $# -gt 6 ] ; then
        echo "testInputBash: You've entered too many words..." 
        exit 1
fi


#EXIT if factorToIncreaeSplitSize is out of range
factor=$(printf "%.0f" $(echo $1))
if [ $factor -lt 1 ] || [ $factor -gt 30 ] ; then
        echo "testInputBash: The factor you are increasing input split must be greater than 1 and less than 30."
        exit 1
fi

#Tell user whether input is good 
echo "testInputBash: PRELIMINARY ARGUMENT CHECK FOR PUNCTUATION AND EXCESS WORDS DONE. IF # ENTERED AS AN ARGUMENT testInputBash CANNOT DETERMINE VALIDITY OF ARGUMENTS"
