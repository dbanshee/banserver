#! /bin/bash

nArgs=$#
if [ $nArgs == 2 ] ; then
  userName=$1
  dirName=$2
else
  echo "Invalid arguments"
  echo "Usage : createMailDirs.sh <userName> <homePath>"
  exit -1
fi


cp -r /etc/skel/Maildir ${dirName}
chown -R ${userName}:${userName} ${dirName}
chmod -R 700 ${dirName} 

echo "Maildir initialized at ${dirName}"
