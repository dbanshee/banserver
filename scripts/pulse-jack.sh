#! /bin/bash

function startBridge () {
    echo "Starting Pulse-Alsa bridge ..."
    pactl suspend-sink alsa_output.pci-0000_00_1b.0.analog-stereo 1 || exit 1
    pactl set-default-sink jack_out || exit 1
} 

function stopBridge () {
    echo "Stopping Pulse-Alsa brigde ..."
    pactl unload-module module-jack-sink || exit 1
    pactl load-module module-jack-source || exit 1
    pactl suspend-sink alsa_output.pci-0000_00_1b.0.analog-stereo 0 || exit 1
    pactl set-default-sink alsa_output.pci-0000_00_1b.0.analog-stereo || exit 1
}

function infoBridge () {
    echo "Info Pulse-Alsa brigde ..."
    pactl info
}

function error () {
    echo "Invalid arguments"
    echo "Usage : pulse-alsa.sh <start|stop|info>"
    exit 1
}


nArgs=$#
if [ $nArgs = 1 ] ; then
  if [ "$1" = "start" ] ; then
    startBridge
  elif  [ "$1" = "stop" ] ; then
    stopBridge
  elif [ "$1" = "info" ] ; then
    infoBridge
  else
    error
  fi
else
  error
fi
