#! /bin/bash

function usage () {
  echo -e "Usage : cpstat.sh <source> <destination>\n"
}

function badArgs () {
  echo "Invalid arguments"
  usage
}

nArgs=$#
if [ $nArgs -eq 0  ] ; then
  usage 
  exit 0
elif [ $nArgs -ne 2 ] ; then
  badArgs 
  exit 1
fi

tar c "$1" | pv | tar x -C "$2"
