UPDATE: 
This experiment was featured at the the 2016  GENI Regional Workshop at Arizona State University. 
https://witestlab.poly.edu/blog/a-hadoop-powered-book-recommendation-system/


Feb. 27, 2016
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

5. 	Become the hadoop user, cd to /home/hadoop, and execute hadoopStart.sh
	to configure your hadoop environment. 
	Type:
		sudo su hadoop -
		cd /home/hadoop
		./startHadoop.sh	<--- (see NOTES)

##################################################
RUN THE EXPERIMENT!
##################################################
You are now ready to run experiment script: ./exprStart.sh. 
Make sure you are hadoop@master, and that your working directory is /home/hadoop.

Example experiment run:  "./exprStart.sh 1 frog bear"

(This number btw the scriptname and list of interests represents the factor  by which to
to increase the logical block size a map job works on.)

Finally, just go to your machines IP address to see your recommendations.


##################################################
NOTES: Stuck at 0%?
##################################################
1)It has been observed that occassionally while executing "./startHadoop.sh" your Hadoop environment may indicate that worker-0 or worker-1 has encountered a routing error. If this is the case, your MapReduce will get stuck at 0% 0%. Delete your resources and start the experiment again if you notice your job not starting. 

2)If you interrupt your MapReduce run, the next time you run "exprStart.sh" your job may be stuck at 0%. This can be resolved by following the steps outlined in "restartYARN.sh"

