#! /bin/bash

function abort () {
  echo "abort"
  #killall alsa_in
  #killall alsa_out
  pkill -P $$
}

trap abort SIGTERM SIGKILL SIGINT

alsa_in -j outloop -doutloop &
alsa_out -j inloop -dinloop &
#alsa_in -j outloop -doutloopdsnoop &
#alsa_out -j inloop -dinloopdsnoop &

read
abort
