#! /bin/bash

CHANNEL_NAME="channel2"

# Use Loopback Subdevice 1 
ALSA_INPUT_DEVICE="hw:Loopback,1,1"
ALSA_OUTPUT_DEVICE="hw:Loopback,0,1"

function abort () {
  echo "abort"
  pkill -P $$
  exit 0
}

trap abort SIGTERM SIGKILL SIGINT

function usage () {
  echo -e "Usage : radioStream.sh [source_folder]\n"
}

function badArgs () {
  echo "Invalid arguments"
  usage
  exit 1
}

nArgs=$#

if [ $nArgs -ne 1 ] ; then
  badArgs
else
  FOLDER_PATH="$1"
fi

if [ ! -d $FOLDER_PATH] ; then
  echo "Directory '$FOLDER_PATH' not exists"
  exit 1
fi

REAL_FOLDER_PATH=$FOLDER_PATH
echo "Music Path : $REAL_FOLDER_PATH"

# Create Stream Radio Channel
echo -e "Creating Stream Radio Channel : '$CHANNEL_NAME' on alsa device '$ALSA_OUTPUT_DEVICE'"

# Icecast dump from alsa device
streamIcecast.sh direct $CHANNEL_NAME $ALSA_OUTPUT_DEVICE &
if [ $? -ne 0 ] ; then
  echo "Error creating icecast channel $CHANNEL_NAME"
  exit 1
fi

# Play songs
while :
do
  SONG_PATH=`find "$REAL_FOLDER_PATH" \( -name '*.mp3' -or \
					 -name '*.mogg' -or \
					 -name '*.ogg'  \) \
             | sort -R --random-source=/dev/urandom | tail -n 1`

  echo -e "\nPlaying : '$SONG_PATH' ..."
  lame --decode "$SONG_PATH" - | aplay -vv -D $ALSA_INPUT_DEVICE &
  PLAYER_PID=$!
  echo "Player pid : $PLAYER_PID"

  while kill -s 0 $PLAYER_PID > /dev/null ; do
    read -t 1 KEY
    if [ $? -eq 0 ] ; then
      echo "Skipping current song ..."
      kill $PLAYER_PID
    else
     sleep 1
    fi
  done  
done
