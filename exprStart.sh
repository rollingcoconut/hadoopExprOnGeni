#! /bin/bash

########################################
# exprStart.sh
# GENI HADOOP MOOC 
# script useage:  {./scriptname, factor2IncreaseInputSplit, interests }
# the interests should be single words without digits; a max of five words should be given
#       words should not be repeated
########################################

echo "exprStart:YOU ARE RUNNING THE BOOK REC SYSTEM WITH THE TERM FREQ ALGORITHM. TO GET MORE ACCURATE RESULTS USE THE SCRIPT EMPLOYING THE TF.IDF ALGORITM."

auxFolder=$(pwd)/AUX_FILES   # 	PATH TO AUX_FILES 

#Test input for punctuation, upper-cases, arg. length, factorToIncreaseInputSplitRange
#$(pwd)/AUX_FILES/testInputBash $*
$auxFolder/testInputBash.sh $*
ret=$?
if [ $ret -ne 0 ] ; then
        echo "exprStart: quit because of either input's syntax, length; or factorRange not number.  EX: ./exprStart.sh 1 frogs" ; exit 1
fi

#Test if factorToEnlargeInputSplit is integer
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
   echo "exprStart quit because factorToIncreaseInputSplit not integer. EX: ./exprStart.sh 1 frogs" ; exit 1
fi


#To enable the unix sort you need the right encoding
export LC_NUMERIC=en_US.utf-8

#DETERMINE SIZE of mapred.min.split.size by determining avg block size;
#THE UNIX PROGRAM 'bc' must be installed 
initInputFileSize=`hdfs fsck /x00 | grep avg. | grep -oP '(?<!\d)\d{6,}(?!\d)'`
factor=$1
finalInputFileSize=$(printf "%.0f" $(echo "$initInputFileSize*$factor" | bc -l))
partic=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
outputFile=$(date +%s)
outputFile=$partic$outputFile

# TEST IF SOMEONE RUNNING PRGM AT SAME SECOND
# testDate returns 1 if output file already exists
$auxFolder/testDate.sh $outputFile
outputFileDNE=$?         	# GET EXIT CODE FORM testDate
if [ $outputFileDNE -ne 0 ] ; then
        echo "exprStart:Someone starting prgm at same second. Try again" ; exit 1
fi
echo "exprStart: PROGRAM WILL NOW EXECUTE HADOOP MAPREDUCE JOB" 
echo "exprStart: input split size is: " $initInputFileSize 
echo "exprStart: mapred.min.split.size is " $finalInputFileSize 

#START HADOOP MAPREDUCE JOB! MAPPER AND REDUCER ARE IN AUX_FILES
yarn jar \
	/home/hadoop/hadoop-2.7.1/share/hadoop/tools/lib/hadoop-streaming-2.7.1.jar    \
	-D mapred.min.split.size=$finalInputFileSize \
	-files ./AUX_FILES/mapper.py,./AUX_FILES/reducer.py,AUX_FILES/nltk.mod   -mapper "mapper.py $*"  -reducer reducer.py  \
	-input /x00 -output  /$outputFile



#CREATE HTML PAGE
cat $auxFolder/indexBeg.txt > $auxFolder/index.html

#POPULATE HTML PAGE WITH FORMATTED MAPREDUCE JOB OUTPUT
hadoop fs -cat /$outputFile/part-00000 | sort -r | head -10 | ./AUX_FILES/parseOutputMP_v2.py | uniq  | ./AUX_FILES/createHTMLpage.sh > $auxFolder/tempRes.html

#DID MAPREDUCE JOB RETURN ANYTHING
if [[ ! -s $auxFolder/tempRes.html ]] ; then
echo "<p>Sorry. No results found</p>" >  $auxFolder/tempRes.html
fi 

#FINISH CREATING HTML PAGE
cat $auxFolder/tempRes.html >> $auxFolder/index.html
cat $auxFolder/indexEND.txt >> $auxFolder/index.html
if [ $? -eq 0 ]; then echo "exprSTART: HTML PAGE CREATED" ; 
else echo "SOMETHING WENT WRONG WHILE CREATING HTML PAGE...";  exit 1 ; fi


#PLACE HTML FILE APPROPRIATELY
if [ -d /var/www/html ]; then
	if [  -f /var/www/html/index.html ]; then
		cp $auxFolder/index.html /var/www/html/index.html
		ret=$?
		if [ $ret -ne 0 ] ; then echo "SOMETHING WENT WRONG MOVING FILE TO /VAR/WWW/HTML..." ; fi
		echo "exprStart: INDEX.HTML ALREADY EXISTS! IT HAS BEEN WRITTEN OVER. ACCESS MAPREDUCE OUTPUT AT machineIP" 
	fi
	echo "exprStart: IN CASE YOU DO NOT HAVE A WEB SERVER RUNNING, HERE ARE YOUR RECOMMENDATIONS."
	cat $auxFolder/tempRes.html
fi
hadoop fs -rm -r /$outputFile 

#EXPERIMENT FUNCTIONALITY TO PRESENT NUMBER OF MAPS/REDUCES; NOT SUPPORTED IN V2
#hadoop job -history all /user/{username}/$outputFile | grep Kind | grep Total
#hadoop job -history all /user/{username}/$outputFile | grep Map
#echo "Total Runtime:"
#hadoop job -history all /user/{username}/$outputFile | grep Finished | grep At
