#!/bin/bash

function check_arguments() {
  if [[ $# -ne 4 ]]; then
    echo "4 parameters are required"
    exit
  fi

  for value in $@; do
    if [[ -z $(echo $value | grep "^[1-6]$") ]]; then
      echo "invalid argument : $value . Available arguments 1-6"
      exit
    fi
  done

  if [[ $1 -eq $2 ]] || [[ $3 -eq $4 ]]; then
    echo "The color of the font and the background must not match, try running with the first parameter not equal to the second parameter and the third parameter not equal to the fourth"
  fi
}
