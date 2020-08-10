#! /bin/bash

#
# Banshee - 2020
#
# Banserver Script for stream Alsa device to Icecast2 Server
#



DEFAULT_STREAM_NAME="channel1"

ALSA_DEVICE=outloopdsnoop
#ALSA_DEVICE=outloop
#ALSA_DEVICE="hw:Loopback,1,0" # Device 1, Subdevice 0
#ALSA_DEVICE="hw:Loopback,1,1" # Device 1, Subdevice 1

ICECAST_DIRECT="icecast://source:sourcepass@localhost:3000"
ICECAST_LOCAL="icecast://source:sourcepass@192.168.15.10:3000"
ICECAST_REMOTE="icecast://source:sourcepass@banserver.bansheerocks.com:9730"

ICECAST_URL=$ICECAST_DIRECT
STREAM_NAME=$DEFAULT_STREAM_NAME

# Mp3 Preset
PRESET1_MP3_CODEC="aac"
PRESET1_MP3_CTYPE="'audio/aac'"
PRESET1_MP3_HEADER="adts"

# Ogg Preset
PRESET2_OGG_CODEC="vorbis"
PRESET1_OGG_CTYPE="'audio/ogg'"
PRESET1_OGG_HEADER="ogg"

# Default Preset
CODEC=$PRESET1_MP3_CODEC
CTYPE=$PRESET1_MP3_CTYPE
HEADER_FORMAT=$PRESET1_MP3_HEADER


function usage () {
  echo -e "Usage : streamIcecast.sh [<direct|local|remote>] [stream_name] [alsa_device]\n"
  echo -e " example: streamIcecast.sh direct channel1 hw:Loopback,1,0\n"
  echo -e " Play examples:\n"
  echo -e "  lame --decode file.mp3 - | aplay -vv -D hw:Loopback,1"
  echo -e "  sox -q file.mp3 -t wav -b 16 -r48k - | aplay -vv -D hw:Loopback,1"
  echo -e "\n"
}

function badArgs () {
  echo "Invalid arguments"
  usage
  exit 1
}

function abort () {
  pkill -P $$
  exit 0
}

trap abort SIGTERM SIGKILL SIGINT


nArgs=$#

if [ $nArgs -gt 3 ] ; then
  badArgs  
else
  if [ $nArgs -ge 1 ] ; then
    if [ "$1" = "-h" ] ; then
     usage
     exit 0
    elif [ "$1" = "direct" ] ; then
      ICECAST_URL=$ICECAST_DIRECT
    elif  [ "$1" = "local" ] ; then
      ICECAST_URL=$ICECAST_LOCAL
    elif  [ "$1" = "remote" ] ; then
      ICECAST_URL=$ICECAST_REMOTE
    else
      badArgs
    fi

    if [ $nArgs -ge 2 ] ; then
      STREAM_NAME="$2"
    fi

    if [ $nArgs -ge 3 ] ; then
      ALSA_DEVICE="$3"
    fi
  fi
fi


ICECAST_URL="${ICECAST_URL}/${STREAM_NAME}"
HTTP_URL="http://`echo $ICECAST_URL | cut -d'@' -f2`"

echo "------------------------------------------------------------------------------"
echo " Stream Icecast  - $(date)"
echo
echo "  Alsa Device   : ${ALSA_DEVICE}"
echo "  Channel       : ${STREAM_NAME}"
echo "  Icecast URL   : ${CODEC}"
echo "  Audio Codec   : ${ICECAST_URL}"
echo "  Stream Url    : ${HTTP_URL}"
echo "------------------------------------------------------------------------------"
echo

echo -e "  Publishing into URL : http://${HTTP_URL}\n"

ffmpeg -f alsa -i $ALSA_DEVICE -acodec $CODEC -content_type $CTYPE -vn -f $HEADER_FORMAT "$ICECAST_URL"

