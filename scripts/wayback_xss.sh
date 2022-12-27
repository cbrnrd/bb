#!/bin/bash

## This script uses kxss to search for reflected parameters in all urls in the input file
# Tools:
#  - kxss
#  - waybackurls

while read line; do
    domain=$(echo $line | unfurl format %d | awk -F '.' '{print $(NF-1)"."$NF}')
    mkdir -p ../data/$domain
    echo $line | waybackurls | kxss | tee -a ../data/$domain/kxss.txt
done
