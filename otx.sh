#!/bin/bash
#
## links:
# otx endpoints: https://gist.github.com/chrisdoman/3cccfbf6f07cf007271bec583305eb92
# https://www.freecodecamp.org/news/comments-in-json/
# python version: https://github.com/mohamedaymenkarmous/alienvault-otx-api-html
#
#
version="2025-04-10/hefa@trifork.com"
vol_resfile=$0.json
vol_tmpfile=$0.tmp

while :
do
echo -e "\n--- code: $0 --- version: $version ---"
echo -e "input IPv[4], [E]mail, [D]omain, [J]son-file, [H]elp or [Q]uit?"
echo " "
read -p  "you? >>>" -n 1 confirm   # && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
confirm=${confirm^^} # uppercase
echo -e "\n$confirm\n"

if [[ $confirm == "Q" ]] ; then exit
fi

if [[ $confirm == "J" ]] ; then less $vol_resfile
fi

if [[ $confirm == "4" ]] 
then 
  read -p  "IPv4 address? >>>" -n 20 confirm # && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
  confirm=${confirm^^} # uppercase
  echo -e "\n$confirm"
  echo "[" > $vol_resfile

  echo -e "\n= Get Reports, Adversary from hostname ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/IPv4/$confirm/ --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Get GEO information ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/IPv4/$confirm/geo --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Get reverse DNS ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/IPv4/$confirm/passive_dns --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Get malware ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/IPv4/$confirm/malware --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Get malware file details ="
  curl https://otx.alienvault.com/api/v1/indicator/IPv4/$confirm/malware --silent  | python -m json.tool | grep hash | awk '{print $2}'  | cut -d "\"" -f 2 > $vol_tmpfile
  while read -r line
  do 
    echo "  [i] $line" 
    vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/file/$line  --silent | python -m json.tool);    echo "$vol_s," >> $vol_resfile
  done <  $vol_tmpfile

  echo -e "[i] = Get HTTP(s) Scan Data ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/IPv4/$confirm/http_scans --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile
 
  echo -e "[i] = URL list ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/IPv4/$confirm/url_list --silent | python -m json.tool);  echo "$vol_s" >> $vol_resfile

  echo "]" >> $vol_resfile
fi	

if [[ $confirm == "E" ]] 
then 
  read -p  "E-mail address? >>>" -n 80 confirm # && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
#  confirm=${confirm^^} # uppercase
  echo -e "\n$confirm\n"
  echo -e "[i] = Get Reports, Adversary from E-mail ="
  echo "[" > $vol_resfile
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/email/$confirm --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile
  echo -e "[i] = Domains from reverse-whois search ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/email/$confirm/whois --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile
  echo "]" >> $vol_resfile
fi	


if [[ $confirm == "D" ]] 
then 
  read -p  "Domain? >>>" -n 80 confirm # && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
#  confirm=${confirm^^} # uppercase
  echo -e "\n$confirm\n"
  echo  -e "\n\n= Get Reports, Adversary from e-mail ="
  echo "[" > $vol_resfile

  echo -e "[i] = General ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/url/$confirm/general --silent | python -m json.tool); echo "$vol_s," >> $vol_resfile

  echo -e "\n= Get Filehashes from hostname ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/hostname/$confirm/malware --silent | python -m json.tool)
  echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Get Whois data from a hostname ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/hostname/$confirm/whois --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile

#  echo -e "\n= Get Whois data from a hostname II ="
#  vol_s=$(curl https://otx.alienvault.com/indicator/hostname/$confirm --silent | python -m json.tool)
#  echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Get HTTP(S) Scan Data ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/hostname/$confirm/http_scans --silent | python -m json.tool); echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Get HTTP(S) Scan Data II ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/hostname/$confirm/http_scans --silent | python -m json.tool);  echo "$vol_s," >> $vol_resfile

  echo -e "[i] = Passive DNS ="
  vol_s=$(curl https://otx.alienvault.com/api/v1/indicator/hostname/$confirm/passive_dns --silent | python -m json.tool);  echo "$vol_s" >> $vol_resfile
fi	

if [[ $confirm == "H" ]] 
then 
# HELP
  echo -e "API calls to OTX Alienvault: https://otx.alienvault.com/assets/static/external_api.html#api_v1_indicators \n\n"
  echo -e "https://otx.alienvault.com  henryhacker / DetteErM1tK0de0rd33!  OTX key: c55dcd306177d51c8f5cda2df1ba2eae3c29dc6a1bb87078cbb760e8d9a30901  \n"
  echo -e "\n\n Go googling or binging .....\n\n"
fi 
done
