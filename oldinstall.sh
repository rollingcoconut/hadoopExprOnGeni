#! /bin/bash 

##################################################
# INSTALL.sh
# GENI HADOOP Project @ NYU Tandon
# purpose of script: Get environment to run experiment. 
#	The experiment is not run as root, but as user hadoop. 
#	Specifically this script does the following: 
# 		1)Move experiment files to hadoop user directory 
#		2)Install webserver 
#		3) Install needed linux tools: bzip decompressor, bc, httpd 
##################################################

echo "install.sh: Hello, "$USER".  This install script will get your GENI machine ready to run a Hadoop powered experiment."

#MOVE EXPERIMENT FILES TO RIGHT PLACE AND CHANGE PERMISSIONS
chmod -R 777  $(pwd)
	cp -r $(pwd)/AUX_FILES /home/hadoop	 #MOVE EXPERIMENT FILES TO RIGHT PLACE
	cp -r $(pwd)/templated-entryway /home/hadoop	 
	cp  $(pwd)/restartYARN.sh /home/hadoop	
	cp  $(pwd)/startHadoop.sh /home/hadoop	 
	cp  $(pwd)/exprStart.sh /home/hadoop	 
chmod -R 777 /home/hadoop/AUX_FILES 
	if [[ $? -ne 0 ]] ; then 
		echo "install.sh: Please move HADOOP_EXPR_v2 directory to /home/hadoop manually
		Then restart install script. Remember the script must be run as superuser."; exit 1 ; fi
[[ $? -eq 0 ]] && echo "install.sh: HADOOP_EXPR_v2 moved successfully to /home/hadoop"

#INSTALL NEEDED LINUX TOOLS
echo -n "install.sh: Get  needed linux tools 'bzip2' and 'bc'? [y/n]: "
read  response
[ "$response" = "y" ] &&  yum install bc bzip2
sleep 3

#GET GUTENBERG CORPUS FILE
echo "install.sh: Moving Gutenberg file to /home/hadoop"
echo "install.sh: Untarring Gutenberg file needed for exprStart.sh"
sleep 3
tar -xvf $(pwd)/AUX_FILES/stopNStemmedA.tar.bz2 -C /home/hadoop || echo "install.sh:Unable to move gutenberg file to /home/hadoop"

#GET INSTALL WEBSERVER
echo "install.sh: Install webserver needed to view experiment results [y/n]?"
read response
if [ "$response" = "y" ] ; then 
	yum update
	yum install httpd
fi 

sleep 1

#MOVE HTML FILES TO /VAR/WWW/HTML
cp -r $(pwd)/templated-entryway/* /var/www/html || echo "install.sh: Something went wrong moving the directory containing CSS and HTML, $(pwd)/templated-entryway to /var/www/html" 

chmod 777 /var/www/html/index.html || echo "install.sh: Something went wrong executing chmod 777 /var/html/www/index.html"

#START WEBSERVER
echo -n  "The webserver will be started. If you do not want to do this, type n, otherwise just press [ENTER]"
read response
[ "$response" = "n" ]  || service httpd start


#TELL USER SCRIPT DONE
echo "install.sh: Script done. Now please run do the following: 
1) sudo su hadoop -
2) cd /home/hadoop
3) ./startHadoop.sh"

