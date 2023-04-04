#!/bin/bash

function topFolders {
    echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
    topDirs=$(find $1 -mindepth 1 -type d -exec du -s {} \; | sort -nr | head -5 | awk '{print $2}')
    number=1
    for filename in ${topDirs[@]}
    do
      echo "$number - $filename, $(du -sh $filename  | awk '{print $1}' | sed -e 's/M/ MB/' -e 's/K/ KB/' -e 's/G/ GB/' )"
      number=$[ number + 1 ]
    done
}

function top10files {
    echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
    defaultFiles=($( find $1 -mindepth 1 -type f -exec ls -s {} \; | sort -nr | head -10 | awk '{print $2}'))
    number=1
    for var in ${defaultFiles[@]}
    do
      echo $number "-" $var "$(du -h $var | awk '{print $1}' | sed -e 's/M/ MB/' -e 's/K/ KB/' -e 's/G/ GB/' ), $(echo $var | sed 's/.*\.//' )"
      number=$((number + 1))
    done
}

function top10exe {
    echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file)"
    exeFiles=($( find $1 -mindepth 1 -type f -executable -exec ls -s {} \; | sort -nr | head -10 | awk '{print $2}'))
    number=1
    for var in ${exeFiles[@]}
    do
      echo $number "-" $var "$(du -h $var | awk '{print $1}' | sed -e 's/M/ MB/' -e 's/K/ KB/' -e 's/G/ GB/' ), $(md5sum $var | awk '{print $1}' )"
      number=$((number + 1))
    done
}

