#! /bin/bash

EXTERNAL_URL="http://banserver.bansheerocks.com:9780/stream"
STREAM_BASE_PATH="/var/www/html/stream"
STREAM_BASE_FILENAME="mystream"

DEFAULT_FORMAT="h264"
DEFAULT_FILE_EXTENSION="mp4"

function badArgs () {
  echo "Invalid arguments"
  echo "Usage : stream2File.sh <mp4|webm|ogg>"
  exit 1
}

function clean () {
  echo " Deleting Temp Streaming Files : ${STREAM_BASE_PATH}/*"
  rm -rf "${STREAM_BASE_PATH}"/*
}

function abort () {
  echo "Finishing stream"
  clean
  exit
}


function h264Params () {
  AUDIO_CODEC="aac"
  FILE_EXTENSION="mp4"
  EXTRA_PARAMS=""
}

function vp8Params () {
  AUDIO_CODEC="libvorbis"
  FILE_EXTENSION="webm"
  EXTRA_PARAMS=""
}

function theoraParams () {
  AUDIO_CODEC="libvorbis"
  FILE_EXTENSION="ogg"
  EXTRA_PARAMS=""
}

trap abort SIGTERM SIGKILL SIGINT

clean

nArgs=$#
echo "$nArgs"
if [ $nArgs -eq 0 ] ; then
  h264Params
elif [ $nArgs -eq 1 ] ; then
  if [ "$1" = "mp4" ] ; then
    h264Params
  elif  [ "$1" = "webm" ] ; then
    vp8Params
  elif  [ "$1" = "ogg" ] ; then
    theoraParams
  else 
    badArgs
  fi
else
  badArgs
fi

STREAM_FILENAME="${STREAM_BASE_FILENAME}.${FILE_EXTENSION}"
STREAM_URL="${EXTERNAL_URL}/${STREAM_FILENAME}"
STREAM_PATH="${STREAM_BASE_PATH}/${STREAM_FILENAME}"
echo "Stream URL: ${STREAM_URL}"
ffmpeg -f alsa -i outloopdsnoop -acodec "${AUDIO_CODEC}" "${STREAM_PATH}"


