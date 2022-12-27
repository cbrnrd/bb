#!/bin/bash
## This script gets all active js files from each subdomain in the input list
# Tools:
#  - httpx
#  - katana

if [ -z "$1" ]; then
    echo "Usage: ./get_js_files.sh <domain_list.txt>"
    exit 1
fi

# Get top level domain from an entry in $1. should be *.*.*.domain.tld
top_domain=$(head -n 1 $1 | awk -F '.' '{print $(NF-1)"."$NF}')

mkdir -p ../data/$top_domain

cat $1 | httpx -silent | katana -d 5 -silent -em js,jsp,json > ../data/$top_domain/js_files.txt

