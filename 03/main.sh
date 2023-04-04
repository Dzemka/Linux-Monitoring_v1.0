#!/bin/bash
. ./checkArguments.sh
. ./calculateMask.sh
err=$(check_arguments $@)
if [[ -n $err ]]; then
  echo $err
  exit
fi

color=(97 91 92 94 95 30)
c1="\e[$((${color[$1 - 1]} + 10));$((${color[$2 - 1]}))m"
c2="\e[$((${color[$3 - 1]} + 10));$((${color[$4 - 1]}))m"
c0="\e[0m"
array[0]="HOSTNAME $(hostname)"
array[1]="TIMEZONE $(timedatectl | awk '/Time zone/{print $3}') UTC $(date +"%-:::z")"
array[2]="USER $(logname)"
array[3]="OS $(cat /etc/os-release | awk -F= '/PRETTY_NAME/{print $2}' | sed 's/"//g')"
array[4]="DATE $(date +"%d %b %Y %T")"
array[5]="UPTIME $(uptime -p | sed 's/up //')"
array[6]="UPTIME_SEC $(cat /proc/uptime | awk -F"." '{print $1}')"
ip=$(hostname -I | head -1)
array[7]="IP $(echo $ip)"
mask=$(ip -br a | grep $ip | awk '{print $3}' | awk -F"/" '{print $2}')
mask=$(calculateMask $mask)
array[8]="MASK $mask"
array[9]="GATEWAY $(ip route | head -1 | awk '{print $3}')"
array[10]="RAM_TOTAL $(free -b | awk '/Mem/{printf "%.3f", $2 / 1000000000}') GB"
array[11]="RAM_USED $(free -b | awk '/Mem/{printf "%.3f", $3 / 1000000000}') GB"
array[12]="RAM_FREE $(free -b | awk '/Mem/{printf "%.3f", $4 / 1000000000}') GB"
array[13]="SPACE_ROOT $(df | awk '/\/$/{printf "%.2f", $2 / 1000}') MB"
array[14]="SPACE_ROOT_USED $(df | awk '/\/$/{printf "%.2f", $3 / 1000}') MB"
array[15]="SPACE_ROOT_FREE $(df | awk '/\/$/{printf "%.2f", $4 / 1000}') MB"

for forPrint in "${array[@]}"; do
  data=($forPrint)
  echo -en " ${c1}${data[0]}${c0} = "
  unset data[0]
  echo -e "${c2}${data[@]}${c0}"
done
