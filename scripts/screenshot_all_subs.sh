#!/bin/bash
## This tool takes a list of domains and takes a screenshot of each subdomain
# Tools:
#  - httpx
#  - nuclei

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ -z "$1" ]; then
    echo "Usage: ./screenshot_all_subs.sh <domain_list.txt>"
    exit 1
fi

# Get top level domain from an entry in $1. should be *.*.*.domain.tld
top_domain=$(head -n 1 $1 | awk -F '.' '{print $(NF-1)"."$NF}')

mkdir -p ../data/$top_domain/screenshots

echo -n "Taking screenshots of all subdomains... "

httpx -l "$1" -silent | nuclei -headless -t headless/screenshot.yaml -silent

if [ $? -eq 0 ]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAIL${NC}"
    exit 1
fi

# Move screenshots to screenshots directory
mv -f *.png ../data/$top_domain/screenshots

echo -e "Screenshots saved to ${YELLOW}../data/$top_domain/screenshots${NC}"

