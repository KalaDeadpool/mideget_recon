#! /bin/bash

if [ -z "$1" ];then
	figlet "Baby Recon" -c -f /usr/share/figlet/pagga.tlf | lolcat
	printf "\n--------------------------------------------------------------------------------\n\n"
	echo "Usage: ./baby_domain.sh <domain> <path to save file>"
	exit 1
else
	domain=$1

fi
printf "\n....Waf00f.....\n\n" > $2
wafw00f $domain >> $2

figlet "######################################" -f /usr/share/figlet/digital.flf | lolcat

printf "\n.....Host....\n\n" >> $2
echo "[+]Executing host" 
host $domain >> $2

figlet "######################################" -f /usr/share/figlet/digital.flf | lolcat

printf "\n.....Whois.....\n\n" >> $2
echo "[+]Executing whois"
whois $domain >> $2

figlet "######################################" -f /usr/share/figlet/digital.flf | lolcat

f=/home/pool/Documents/custom_babies
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

figlet "######################################" -f /usr/share/figlet/digital.flf | lolcat

echo "[+]Executing nikto scan and looking for vulnerabilities"
nikto -host $domain

figlet "######################################" -f /usr/share/figlet/digital.flf | lolcat


for i in {0..5}
do
	sources=(crtsh urlscan hackertarget otx dnsdumpster facebook)
	echo "[+]Executing theHarvester -d $domain -b ${sources[i]} -f theHarvester"
	theHarvester -d $domain -b ${sources[i]} -f $2.theHarvester 
done





