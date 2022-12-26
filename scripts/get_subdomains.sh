# Gets all subdomains from a given top level domain
# Tools:
#  - amass
#  - subfinder
#  - assetfinder

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get domain from $1
domain=$1

# Check if domain is set
if [ -z "$domain" ]; then
    echo "Usage: ./get_subdomains.sh <domain>"
    exit 1
fi

# Create output directory
mkdir -p ../data/$domain

# Get subdomains with amass
echo -n "Getting subdomains with amass... "
amass enum -d $domain -o ../data/$domain/amass_subs.txt 2>&1 > /dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAIL${NC}"
    exit 1
fi

# Get subdomains with subfinder
echo -n "Getting subdomains with subfinder... "
subfinder -silent -all -d $domain -o ../data/$domain/subfinder_subs.txt 2>&1 > /dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAIL${NC}"
    exit 1
fi

# Get subdomains with assetfinder
echo -n "Getting subdomains with assetfinder... "
assetfinder --subs-only $domain > ../data/$domain/assetfinder_subs.txt 2>&1 > /dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}OK${NC}"
else
    echo -e "${RED}FAIL${NC}"
    exit 1
fi

# Combine subdomains and remove duplicates
cat ../data/$domain/amass_subs.txt ../data/$domain/subfinder_subs.txt | sort -u > ../data/$domain/subdomains.txt

# Remove temporary files
rm ../data/$domain/amass_subs.txt ../data/$domain/subfinder_subs.txt ../data/$domain/assetfinder_subs.txt

# Print number of subdomains
echo -e "Found ${YELLOW}$(wc -l ../data/$domain/subdomains.txt | cut -d ' ' -f 1)${NC} subdomains"
