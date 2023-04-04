#!/bin/bash
. ./calculateMask.sh

if [[ $# -ne 0 ]]
then
  echo "This script without parameters"
  exit
fi
color=(97 91 92 94 95 30)
colorName=("white" "red" "green" "blue" "purple" "black")
if [ -r monitoring.cfg ]; then
  cfg=($(cat monitoring.cfg))
fi
colorCfg[0]=$(echo ${cfg[0]} | grep -E '(^column1_background=[1-6]$)' | sed s/column1_background=//)
colorCfg[1]=$(echo ${cfg[1]} | grep -E '(^column1_font_color=[1-6]$)' | sed s/column1_font_color=//)
colorCfg[2]=$(echo ${cfg[2]} | grep -E '(^column2_background=[1-6]$)' | sed s/column2_background=//)
colorCfg[3]=$(echo ${cfg[3]} | grep -E '(^column2_font_color=[1-6]$)' | sed s/column2_font_color=//)
if [ ${#cfg[*]} -ne 4 ] || [ -z ${colorCfg[0]} ] || [ -z ${colorCfg[1]} ] || [ -z ${colorCfg[2]} ] || [ -z ${colorCfg[3]} ]; then
    colorCfg=(6 1 2 4)
    defaultColor=1
  else
    defaultColor=0
fi
c1="\e[$((${color[${colorCfg[0]} - 1]} + 10));$((${color[${colorCfg[1]} - 1]}))m"
c2="\e[$((${color[${colorCfg[2]} - 1]} + 10));$((${color[${colorCfg[3]} - 1]}))m"
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
  echo -en "${c1}${data[0]}${c0} = "
  unset data[0]
  echo -e "${c2}${data[@]}${c0}"
done

if [[ defaultColor -eq 1 ]]
then
  colorName=(default default default default default default)
fi
echo

for ((i = 0; i < 4; i ++))
do
  echo -e "Column 1 background = ${colorCfg[$i]} \e[${color[$((${colorCfg[$i]} - 1))]}m(${colorName[$((${colorCfg[$i]} - 1))]})\e[0m"
done
