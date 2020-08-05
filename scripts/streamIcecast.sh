#! /bin/bash

DEFAULT_STREAM_NAME="channel1"

ALSA_DEVICE=outloopdsnoop
#ALSA_DEVICE=outloop

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


function badArgs () {
  echo "Invalid arguments"
  echo "Usage : streamIcecast.sh [<direct|local|remote>] [stream_name]"
  exit 1
}

nArgs=$#

if [ $nArgs -gt 2 ] ; then
  badArgs  
else
  if [ $nArgs -ge 1 ] ; then
    if [ "$1" = "direct" ] ; then
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
  fi
fi


ICECAST_URL="${ICECAST_URL}/${STREAM_NAME}"
HTTP_URL=`echo $ICECAST_URL | cut -d'@' -f2`
echo -e "Stream Alsa to Icecast"
echo -e "  Alsa Device : $ALSA_DEVICE"
echo -e "  Publishing into URL : http://${HTTP_URL}\n"
echo -e " Play example : 'aplay -vv -D hw:Loopback,1 file_example_WAV_2MG.wav'\n\n"

ffmpeg -f alsa -i $ALSA_DEVICE -acodec $CODEC -content_type $CTYPE -vn -f $HEADER_FORMAT "$ICECAST_URL"

