#!/bin/bash
. ./calculateMask.sh

if [[ $# -ne 0 ]]
then
  echo "This script without parameters"
  exit
fi

array[0]="HOSTNAME = $(hostname)"
array[1]="TIMEZONE = $(timedatectl | awk '/Time zone/{print $3}') UTC $(date +"%-:::z")"
array[2]="USER = $(logname)"
array[3]="OS = $(cat /etc/os-release | awk -F= '/PRETTY_NAME/{print $2}' | sed 's/"//g')"
array[4]="DATE = $(date +"%d %b %Y %T")"
array[5]="UPTIME = $(uptime -p | sed 's/up //')"
array[6]="UPTIME_SEC = $(cat /proc/uptime | awk -F"." '{print $1}')"
ip=$(hostname -I | head -1)
array[7]="IP = $(echo $ip)"
mask=$(ip -br a | grep $ip | awk '{print $3}' | awk -F"/" '{print $2}')
mask=$(calculateMask $mask)
array[8]="MASK = $mask"
array[9]="GATEWAY = $(ip route | head -1 | awk '{print $3}')"
array[10]="RAM_TOTAL = $(free -b | awk '/Mem/{printf "%.3f", $2 / 1000000000}') GB"
array[11]="RAM_USED = $(free -b | awk '/Mem/{printf "%.3f", $3 / 1000000000}') GB"
array[12]="RAM_FREE = $(free -b | awk '/Mem/{printf "%.3f", $4 / 1000000000}') GB"
array[13]="SPACE_ROOT = $(df | awk '/\/$/{printf "%.2f", $2 / 1000}') MB"
array[14]="SPACE_ROOT_USED = $(df | awk '/\/$/{printf "%.2f", $3 / 1000}') MB"
array[15]="SPACE_ROOT_FREE = $(df | awk '/\/$/{printf "%.2f", $4 / 1000}') MB"
printf "%s\n" "${array[@]}"
read -p "Save this information to a file? Y(y)\N(n) : " decision
if [ ${decision,,} == "y" ]; then
  printf "%s\n" "${array[@]}" > $(date +"%d_%m_%y_%H_%M_%S").status
fi
