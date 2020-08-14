#! /bin/bash

#
#  Banshee - 2020
#
#  Create Jack clients for alsa devices
#
#
# For list devices: 'aplay -l' , 'arecord -l', '~/.asoundrc'
#
# Jack List ports
#  jack_lsp
#
# Connect/Disconnect Jack Ports
#  jack_connect    cloop:capture_1 system:playback_1
#  jack_disconnect cloop:capture_2 system:playback_2

ALSA_PLAYBACK_DEVICE=ploopdsnoop
ALSA_CAPTURE_DEVICE=cloopdmix

function abort () {
  echo "Closing Jack clients"
  pkill -P $$
  exit 0
}

trap abort SIGTERM SIGKILL SIGINT

# Create Jack Ports
alsa_in  -j cloop -d $ALSA_PLAYBACK_DEVICE &
alsa_out -j ploop -d $ALSA_CAPTURE_DEVICE  &


echo "Press any key to terminate Jack clients ..."
read
abort
