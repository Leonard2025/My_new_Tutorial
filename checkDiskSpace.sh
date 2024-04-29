#!/bin/bash

#read the name of the repository
Directory=$1
# print the space occupation of each file in the directory

if [ du $Directory/* -h ]
 then 
    echo "print the disk occupation of each file"
else

 echo "Do not"
 echo "exit code is: $?"

fi
