#! /bin/sh

########################################
# createHTMLpage.sh
# GENI HADOOP MOOC 
# script useage:  { ./script << Hadoop_MapReduce_Job_output as formatted within exprStart script }
########################################

while read line; do

url="<a href=`echo "$line" | cut -d$'\t' -f3`>"
book="`echo "$line" | cut -d$'\t' -f1`"
score="`echo "$line" | cut -d$'\t' -f2`"
newTD="<tr><td>"
newTD="</td><td>"
endTR="</td></tr>"

	echo $newTD$url$book$newTD$score$endTD

echo "</td></tr>"
done
