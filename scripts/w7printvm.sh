#! /bin/bash

VM_NAME="WIn7_Print"

function isrunning () {
  echo $(VBoxManage list runningvms | grep $VM_NAME | wc -l)
}

function startVM () {
  VBoxManage startvm $VM_NAME --type headless
}

function stopVM () {
  VBoxManage controlvm $VM_NAME acpipowerbutton
}

function forcestopVM () {
  VBoxManage controlvm $VM_NAME poweroff
}


function infoVM () {
  VBoxManage showvminfo $VM_NAME
}

nArgs=$#
if [ $nArgs = 1 ] ; then
  if [ "$1" = "start" ] ; then
    echo "Starting VM ..."
    if [ $(isrunning) = 0 ] ; then
      startVM
    fi
  elif  [ "$1" = "stop" ] ; then
    echo "Stopping VM ..."
    stopVM
  elif  [ "$1" = "force-stop" ] ; then
    echo "Stopping VM ..."
    forcestopVM
  elif [ "$1" = "info" ] ; then
    infoVM
  else
    check=$(isrunning)
    if [ $check = 0 ] ; then
      echo "VM NOT running"
      exit 0
    else 
      echo "VM IS running"
      exit 1
    fi
  fi
else
  echo "Invalid arguments"
  echo "Usage : w7printvm.sh <start|stop|check|info|force-stop>"
  exit 1
fi


