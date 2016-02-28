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
sleep 4

div="






-------------------------------------------------- 
"

#MOVE EXPERIMENT FILES TO RIGHT PLACE AND CHANGE PERMISSIONS
chmod -R 777  $(pwd)
	cp -r $(pwd)/AUX_FILES /home/hadoop	 #MOVE EXPERIMENT FILES TO RIGHT PLACE
	cp -r $(pwd)/templated-entryway /home/hadoop	 
	cp  $(pwd)/restartYARN.sh /home/hadoop	
	cp  $(pwd)/startHadoop.sh /home/hadoop	 
	cp  $(pwd)/exprStart.sh /home/hadoop	 
chmod -R 777 /home/hadoop/AUX_FILES 
[[ $? -ne 0 ]] || 
		echo "install.sh: Please move HADOOP_EXPR_v2 directory to /home/hadoop manually
		Then restart install script. Remember the script must be run as superuser."
[[ $? -eq 0 ]] && echo "install.sh: HADOOP_EXPR_v2 moved successfully to /home/hadoop"

#INSTALL NEEDED LINUX TOOLS
echo "install.sh: Installing needed linux tools: bc, unzip"
yum check-update 
yum -y install bc unzip
[[ $? -eq 0 ]] && echo "install.sh: Successfully installed bc, unzip from repository"
sleep 2

#GET GUTENBERG WORD FREQUENCY FILE
echo "install.sh: Moving Gutenberg file to /home/hadoop"
echo "install.sh: Unzipping Gutenberg file needed for exprStart.sh"
echo "install.sh: (this will take a while)"
wget https://nyu.box.com/shared/static/kbzerbhp2mjktamvrmpiazikg58568ho.zip
unzip kbzerbhp2mjktamvrmpiazikg58568ho.zip -d /home/hadoop

#GET INSTALL WEBSERVER
echo "install.sh: Installing webserver"
yum -y install httpd
[[ $? -eq 0 ]] && echo "install.sh: Successfully installed httpd and its dependencies from repository"
sleep 1

#MOVE HTML FILES TO /VAR/WWW/HTML
cp -r $(pwd)/templated-entryway/* /var/www/html || echo "install.sh: Something went wrong moving the directory containing CSS and HTML, $(pwd)/templated-entryway to /var/www/html" 
chmod 777 /var/www/html/index.html || echo "install.sh: Something went wrong executing chmod 777 /var/html/www/index.html"

#START WEBSERVER
echo  "install.sh:The webserver will be started."
service httpd start
echo  "install.sh: Webserver started on this VM"
sleep 1

#TELL USER SCRIPT DONE
echo $div
echo "install.sh: Script done. Now please run do the following: 
1) sudo su hadoop -
2) cd /home/hadoop
3) ./startHadoop.sh"

