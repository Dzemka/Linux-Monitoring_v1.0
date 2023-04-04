#!/bin/bash
function calculateMask() {
  maskArray=(0 0 0 0)
  octetIndex=$(($1 / 8))
  maskArray[$octetIndex]=$((256 - 2 ** (8 - ($1 % 8))))
  octetIndex=$(($octetIndex - 1))
  while [ $octetIndex -ge 0 ]; do
    maskArray[$octetIndex]=255
    octetIndex=$(($octetIndex - 1))
  done
  echo ${maskArray[0]}.${maskArray[1]}.${maskArray[2]}.${maskArray[3]}
}
