#!/bin/bash
error=$(. ./isCorrect.sh $@)
if [[ $error = 0 ]]
then
  echo $1
else
  echo $error
fi
