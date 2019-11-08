#!/bin/bash


SECRET_FILENAME=/home/banshee/auth-secret
SECRET_SIZE_BYTES=32

if [ ! -f $SECRET_FILENAME ] ; then
  echo "Secret File : '$SECRET_FILENAME' not exists"

  dd if=/dev/urandom bs=${SECRET_SIZE_BYTES} count=1 2> /dev/null | hexdump -v -e '/1 "%02X"' >> $SECRET_FILENAME

fi


