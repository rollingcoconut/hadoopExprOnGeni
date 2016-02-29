#! /bin/bash

########################################
# exprStart.sh
# GENI HADOOP MOOC 
# script useage:  {./scriptname, factor2IncreaseInputSplit, interests }
# the interests should be single words without digits; a max of five words should be given
#       words should not be repeated
########################################

echo "exprStart: You are running the book rec system with the term freq algorithm."

auxFolder=$(pwd)/AUX_FILES   # 	PATH TO AUX_FILES 

#Test input for punctuation, upper-cases, arg. length, factorToIncreaseInputSplitRange
#$(pwd)/AUX_FILES/testInputBash $*
#$auxFolder/testInputBash.sh $*


#Test if factorToEnlargeInputSplit is integer
re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
   echo "exprStart quit because factorToIncreaseInputSplit not integer. EX: ./exprStart.sh 1 frogs" ; exit 1
fi

#Show user the stems of their search terms
echo "exprStart: Your search terms have been stemmed to the following:"
auxFolder=$(pwd)/AUX_FILES   #  PATH TO AUX_FILES 
$auxFolder/showNorm.py $*
sleep 1
ret=$?
if [ $ret -ne 0 ] ; then
        echo "exprStart: quit because of either input's syntax, length; or factorRange not number.  EX: ./exprStart.sh 1 frogs" ; exit 1
fi

#To enable the unix sort you need the right encoding
export LC_NUMERIC=en_US.utf-8

#DETERMINE SIZE of mapred.min.split.size by determining avg block size;
#THE UNIX PROGRAM 'bc' must be installed 
initInputFileSize=`hdfs fsck /stopNStemmedAll | grep avg. | grep -oP '(?<!\d)\d{6,}(?!\d)'`
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
	-files ./AUX_FILES/mapper.py,./AUX_FILES/reducer.py,AUX_FILES/nltk.mod   \
	-mapper "mapper.py $*"  -reducer "reducer.py $#" \
	-input /stopNStemmedAll -output  /$outputFile


#CREATE HTML PAGE
read -d '' indexBeg<<"EOF"
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"> <!-- Design by TEMPLATED http://templated.co Released for free under the Creative Commons Attribution License MODIFIED FOR GENI MOOC PROJECT  Name       : N/A Description: N/A Version    : 1.0 Released   : 20160203 --> <html xmlns="http://www.w3.org/1999/xhtml"> <head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> <title></title> <meta name="keywords" content="" /> <meta name="description" content="" /> <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900" rel="stylesheet" /> <link href="default.css" rel="stylesheet" type="text/css" media="all" /> <link href="fonts.css" rel="stylesheet" type="text/css" media="all" /> <!--[if IE 6]><link href="default_ie6.css" rel="stylesheet" type="text/css" /><![endif]--> </head> <body> <div id="header-wrapper"> <div id="header" class="container"> <div id="logo"> <h1></span><font color="white">AN EXPERIMENT ON GENI: </h1><h2> A Hadoop Powered Book Recommendation System for <i>The Project Gutenberg </i> Corpus </font></h2> <!-- <h1></span><a href="#">EntryWay</a></h1> --> </div> </div> </div> <div id="header-featured"> <div id="elephant_banner" class="container"> </div> </div> <div id="wrapper"> <!-- <div id="featured-wrapper"> --> <!--<div id="featured" class="extra2 margin-btm container">  --> <!--<div class="main-title"> --> <table> <tr><th>Book</th><th>Relevance Score</th></tr> 
EOF
echo $indexBeg > $auxFolder/index.html

read -d '' indexEND<<"EOF"
</table> </br> <span class="byline">Scores are relative to either TF.IDF, or Term Frequency  algorithm</span> </div> </div>	  </div> </div> </div>   <div id="copyright" class="container"> <p>&copy; In collaboration with NYU-Tandon's GENI MOOC Project.   <a href="https://creativecommons.org/licenses/by/2.0/legalcode"> CC BY 2.0</a> |
<a href=" https://www.flickr.com/photos/lmsantana/4670815292/in/photolist-87K9E9-hA2yZP-zbAfM-woXyb-ozC9Ym-qRLbcL-BvZYg-kmz5P5-67NFxz-2PJ8PE-2PDFXi-gTLzfZ-sMrw3-Q5kVp-59Nxjk-67ajaN-e6svuo-8UbZ8T-FJAz8-qwdUey-9qAAK4-6pSZEY-8HywJy-nfYoa-xQ9VX-fP8FzJ-aDEdmU-khHG9H-rVSRTV-7CQsWR-815zjn-DWU3r-6sqzPc-9CgKK2-9gvoT1-ke9gwQ-7VLtGQ-68qn8v-ubcVZ6-6CxwJQ-8ur4Pb-iggDgF-pztehv-6V1qP4-hR3c8i-vdsNA3-6FEEqE-dEXwip-fwYe1f-bNNaTB">Photo</a> by Lucas Santana / <a href="https://creativecommons.org/licenses/by/2.0/legalcode"> CC BY 2.0</a> | Design by <a href="http://templated.co/entryway" rel="nofollow">TEMPLATED</a>.</p> </div> </body> </html>   
EOF

#POPULATE HTML PAGE WITH FORMATTED MAPREDUCE JOB OUTPUT
tempRes=$(hadoop fs -cat /$outputFile/part-00000 | sort -r | head -10 | ./AUX_FILES/parseOutputMP_v2.py | uniq  | ./AUX_FILES/createHTMLpage.sh)


#DID MAPREDUCE JOB RETURN ANYTHING
[ -z "$tempRes" ] && echo "<p>Sorry. No results found</p>" >  $tempRes

#FINISH CREATING HTML PAGE
echo $tempRes >> $auxFolder/index.html
echo $indexEND >> $auxFolder/index.html
if [ $? -eq 0 ]; then echo "exprSTART: html page created" ; 
else echo " something went wrong while creating html page...";  exit 1 ; fi


#PLACE HTML FILE APPROPRIATELY
if [ -d /var/www/html ]; then
	if [  -f /var/www/html/index.html ]; then
		cp $auxFolder/index.html /var/www/html/index.html
		ret=$?
		if [ $ret -ne 0 ] ; then echo " something went wrong moving file to /var/www/html..." ; fi
		echo "exprStart: index.html already exists! it has been written over. access mapreduce output at MACHINEip" 
	fi
	echo "exprStart: in case you do not have a web server running, here are your recommendations."
	hadoop fs -cat /$outputFile/part-00000 | sort -r | head -10 | ./AUX_FILES/parseOutputMP_v2.py | uniq	
fi

#DELETE HDFS OUTPUT FILE
hadoop fs -rm -r /$outputFile 

#EXPERIMENT FUNCTIONALITY TO PRESENT NUMBER OF MAPS/REDUCES; NOT SUPPORTED IN V2
#hadoop job -history all /user/{username}/$outputFile | grep Kind | grep Total
#hadoop job -history all /user/{username}/$outputFile | grep Map
#echo "Total Runtime:"
#hadoop job -history all /user/{username}/$outputFile | grep Finished | grep At
