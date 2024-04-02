#! /bin/bash

generate_banner(){
    	tool_name="$(basename "$0" | cut -c 1-11 | tr '[:lower:]' '[:upper:]')"  # Extract the first two characters of the script name
	echo "===================================================================================="
	echo "                                 $tool_name"
	echo "===================================================================================="
}


if [ -z "$1" ];then
	generate_banner "$0"
	echo "Usage: ./baby_domain.sh <domain> <path to save file>"
	exit 1
else
	domain=$1

fi
printf "\n....Waf00f.....\n\n" > $2
wafw00f $domain >> $2

echo "######################################" 

printf "\n.....Host....\n\n" >> $2
echo "[+]Executing host" 
host $domain >> $2

echo "######################################"

printf "\n.....Whois.....\n\n" >> $2
echo "[+]Executing whois"
whois $domain >> $2

echo "######################################"

f=$(pwd)
subdomain() {
    printf "[+] Executing sublist3r -d $domain -o $f"
    sublist3r -d "$domain" -o "$f/subdomains.txt"

    printf "[+] Sorting the file and deleting duplicate entries!"
    sort -u -o "$f/subdomains.txt" "$f/subdomains.txt"
}
subdomain

printf "\n....Subdomains...\n\n" >> $2
cat "$f/subdomains.txt" >> "$2"


echo "[+]Executing TCP connect scan"
nmap -iL "$f/subdomains.txt" -oX "$f/subdomains.txt.nmap.xml"

echo "######################################"

echo "[+]Executing nikto scan and looking for vulnerabilities"
nikto -host $domain

echo "######################################"


for i in {0..5}
do
	sources=(crtsh urlscan hackertarget otx dnsdumpster facebook)
	echo "[+]Executing theHarvester -d $domain -b ${sources[i]} -f theHarvester"
	theHarvester -d $domain -b ${sources[i]} -f $2.theHarvester 
done





