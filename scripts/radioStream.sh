#! /bin/bash

#
# Banshee - 2020
#
# Banserver Script for stream audio files on Icecast Server
#

CHANNEL_NAME="channel2"

# Use Loopback Subdevice 1 
ALSA_INPUT_DEVICE="hw:Loopback,1,1"
ALSA_OUTPUT_DEVICE="hw:Loopback,0,1"

NPIPE_PATH="/tmp/radioStream.pipe"

function abort () {
  echo "Finishing Radio Service"
 
  # Disable trap. Infinite loop if kill GID.  
  trap '' SIGTERM SIGKILL SIGINT

  # Ctrl+C in bash sends signal to GID. If SIGTERM is sended to bg process only subchilds not receive signals.
  # Send to group.
  GID=$(ps -p $$ -o pgid -h)
  kill -- "-$GID"
  deletePipe
  exit 0
}

trap abort SIGTERM SIGKILL SIGINT


function createPipe () {
  if [ ! -f $NPIPE_PATH ] ; then
    echo "Creating named Pipe '$NPIPE_PATH' ... "
    mkfifo $NPIPE_PATH
  fi
}

function deletePipe () {
  if [ -f $NPIPE_PATH ] ; then
    rm -f $NPIPE_PATH
  fi
}

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

if [ ! -d $FOLDER_PATH ] ; then
  echo "Directory '$FOLDER_PATH' not exists"
  exit 1
fi

REAL_FOLDER_PATH=$FOLDER_PATH

echo "------------------------------------------------------------------------------"
echo " Radio Icecast  - $(date)"
echo
echo "  Alsa Input  Device   : ${ALSA_INPUT_DEVICE}"
echo "  Alsa Output Device   : ${ALSA_OUTPUT_DEVICE}"
echo "  Channel              : ${CHANNEL_NAME}"
echo "  Media Folder         : ${REAL_FOLDER_PATH}"
echo "------------------------------------------------------------------------------"
echo

createPipe

# Create Stream Radio Channel
echo -e "Creating Stream Radio Channel : '$CHANNEL_NAME' on alsa device '$ALSA_OUTPUT_DEVICE'"

# Icecast dump from alsa device
streamIcecast.sh direct $CHANNEL_NAME $ALSA_OUTPUT_DEVICE &
if [ $? -ne 0 ] ; then
  echo "Error creating Icecast channel $CHANNEL_NAME"
  exit 1
fi

# Play Loop
while :
do
  SONG_PATH=`find "$REAL_FOLDER_PATH" \( -name '*.mp3' -or \
					 -name '*.mogg' -or \
					 -name '*.ogg'  \) \
             | sort -R --random-source=/dev/urandom | tail -n 1`

  echo -e "\nPlay Song : '$SONG_PATH' ..."

  lame --decode "$SONG_PATH" - | aplay -vv -D $ALSA_INPUT_DEVICE &
  PLAYER_PID=$!
  echo "Player Pid : $PLAYER_PID"

  while kill -s 0 $PLAYER_PID 2>&1 > /dev/null ; do
    # No puede ejecutarse en BG si se encuentra leyendo de la entrada estandard.
    # Leer de un socket o named pipe
    # '<>': Your shell is blocking on the open() call before invoking the read builtin.
    # On Linux, you can open the FIFO for both read and write at the same time to prevent blocking on open.
    read -t 1 KEY <> $NPIPE_PATH

    if [ $? -eq 0 ] ; then
      echo "Skipping current song ..."
      kill $PLAYER_PID
    else
     sleep 1
    fi
  done  
done
