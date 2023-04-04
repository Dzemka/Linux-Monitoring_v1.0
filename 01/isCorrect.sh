#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Only one parameter is allowed"
elif [ ! -z $(echo $1 | grep -E '(^[+-]?[0-9]{1,}[.]{0,1}[0-9]{0,}$)' ) ]
then
   echo "Values number can't exist"
else
  echo "0"
fi