#! /bin/bash

if [ $# != 1 ] ; then
  echo "Bad Usage: createGitRepo.sh <repName>"
  exit
fi

mkdir $1 || exit
pushd $1
sudo -u git git init --bare --shared
chown -R git:www-data $1 || exit
chmod g+w $1 || exit
popd

