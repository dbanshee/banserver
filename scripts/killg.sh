#! /bin/bash

nArgs=$#
echo "nArgs : $nArgs"

if [ $nArgs -eq 0 ] || [ $nArgs -gt 2 ] ; then
  echo "Bad Args"
  echo " Usage killg.sh [signal] <pid>"
  exit 1
elif [ $nArgs -eq 2 ] ; then
  SIGNAL=$1
  PID=$2
else
  SIGNAL="-SIGTERM"
  PID=$1
fi

GID=$(ps -p $PID -o pgid -h)
if [ -z  $GID ] ; then
  echo "Pid : $PID not found"
  exit 1
fi

kill $SIGNAL -- "-$GID"
