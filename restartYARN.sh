#! /bin/bash

#IF YOUR HADOOP APPLICATION IS STUCK OR DISPLAYING OTHER INCONSISTANCIES, TRY TO RESTART THE CLUSTER
#Run this script AFTER switching to hadoop user: 
#       1) sudo su hadoop -
#		2) cd /home/hadoop

echo "TO RESTART HADOOP. DO THE FOLLOWING:
1) sudo su hadoop -
2) TYPE THE FOLLOWING, pressing [ENTER] on every new line
hadoop-daemons.sh stop datanode
yarn-daemons.sh stop nodemanager
hadoop-daemon.sh stop namenode
yarn-daemon.sh stop resourcemanager
mr-jobhistory-daemon.sh stop historyserver

hadoop-daemons.sh start datanode
yarn-daemons.sh start nodemanager
hadoop-daemon.sh start namenode
yarn-daemon.sh start resourcemanager
mr-jobhistory-daemon.sh start historyserver"
