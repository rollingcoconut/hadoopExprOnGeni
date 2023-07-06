#! /bin/sh

########################################
# testDate
# GENI HADOOP MOOC 
# purpose: stop program in the unlikely event that the experiment is employed on the same machine in the same second
########################################
hadoop dfs -count $1 

if [ $? -eq 0 ] ; then
        echo "Program busy. Try now"
        exit 1
fi
