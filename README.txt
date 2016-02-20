Feb. 20, 2016
A HADOOP POWERED EXPERIMENT ON GENI! 

##################################################
GETTING STARTED: FOR THE GENI RESEARCHER
##################################################
This repository is aimed for GENI users who want to perform an experiment using MapReduce and Hadoop. 

Specifically, the experiment is a book recommendation system for a portion of the Project Gutenberg corpus. 

FYI: In the future, the install scripts may not work because of updates to GENI image used in Rspecs used here.

Follow these minimal steps to get up and running!

##################################################
STEPS
##################################################
1. 	Get a GENI machine using the content of the rspecs.xml file provided here: 
		https://github.com/rollingcoconut/hadoopExprOnGeni.git
	Alternatively, you can configure your machine according to the instructions provided below.  http://groups.geni.net/geni/wiki/GENIExperimenter/Tutorials/jacks/HadoopInASlice/ObtainResources

2. 	SSH into your account on the master node of your machine. 
	Note the ip address of the master node machine! 
	(You will need that ip to see your book recommendations)

3. Get the files you need to run by typing the following:
		git clone https://github.com/rollingcoconut/hadoopExprOnGeni.git

4. Now you'll see a directory called hadoopExprOnGeni. CD into it and execute the install script:
		sudo ./install.sh

NOTE ON STEP 4: The script is interactive
	You will be prompted to download the following linux tools:
	bc, httpd (and dependencies), bzip2. 
	You should download the tools for the experiment to work as expcted.
	NOTE: You will also be asked if you want to start the machine's webserver. 
		You should if you want to see your results optimized via HTTP, but it is not necessary.
		You can always turn machines web server on by typing: 
			sudo serverice httpd start

5. 	Become the hadoop user, cd to /home/hadoop, and execute hadoopStart.sh
	to configure your hadoop environment. 
	Type:
		sudo su hadoop -
		cd /home/hadoop
		./startHadoop.sh

##################################################
RUN THE EXPERIMENT!
##################################################
You are now ready to run experiment script: ./exprStart.sh. 
Make sure you are hadoop@master, and that your working directory is /home/hadoop.

Example experiment run:  "./exprStart.sh 1 apples alice"

(This number btw the scriptname and list of interests represents the factor  by which to
to increase the logical block size a map job works on.)

**A Restriction: To make the experiment modular, restrict the keywords you enter, 
here apples and alice to words beginning with the letter A. 

Entering keywords beginning with other letters will not return any results.  

