#! /bin/bash

virtualenv -p /usr/bin/python3 $1 || exit

echo "Enter virtualenv execute : 'source bin/activate'"
echo "Exit  virtualenv execute : 'deactivate'"
