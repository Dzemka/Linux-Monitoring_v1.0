#!/bin/bash
. tops.sh

begin=$(date +%s.%N)

if [ $# -ne 1 ]
then
  echo "1 parameter is required"
  exit
fi

if [ -z $(echo $1 | awk '/\/$/{print $1}') ] || [ ! -d $1 ]
then
  echo "Parameter error"
  exit
fi

echo "Total number of folders (including all nested ones) = $(find $1 -mindepth 1 -type d | wc -l)"
echo "$(topFolders $1)"
echo "Total number of files = $(find $1 -mindepth 1  -type f | wc -l)"
echo "Number of:"
echo "Configuration files (with the .conf extension) = $(find $1 -mindepth 1 -type f -name "*.conf" | wc -l)"
echo "Text files = $(find $1 -mindepth 1 -type f | grep ".te\?xt$" | wc -l)"
echo "Executable files = $(find $1 -mindepth 1 -type f -executable | wc -l)"
echo "Log files (with the extension .log) = $(find $1 -mindepth 1 -type f -name "*.log" | wc -l)"
echo "Archive files = $(find $1 -name "*.tar"  | wc -l)"
echo "Symbolic links = $(find $1 -type l | wc -l)"
echo "$( top10files $1 )"
echo "$( top10exe $1 )"

end=$(date +%s.%N)
timer=$(echo "$end - $begin" | bc | sed -e 's/^\./0,/' -e 's/\./,/')
#awk 'BEGIN {printf ("%f\n", '$end' - '$begin')} '
printf "Script execution time (in seconds) = %.1lf\n" $timer