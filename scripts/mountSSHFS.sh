#! /bin/bash

SSH_PORT=9722
URL_CON="banshee@banserver.bansheerocks.com"

nArgs=$#
if [ $nArgs != 2 ] ; then
  echo "Bad Usage. mountSSHFS.sh <remotePath> <localPath>"
  exit -1
fi

REMOTE_PATH=$1
LOCAL_PATH=$2

SSH_CMD="sshfs -p ${SSH_PORT} ${URL_CON}:${REMOTE_PATH} ${LOCAL_PATH} -o uid=1000 -o allow_other"
echo $SSH_CMD
eval $SSH_CMD


