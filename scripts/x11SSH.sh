#! /bin/bash


ssh -p 9722 -forever -t -L 5900:localhost:5900 banshee@banserver.bansheerocks.com 'x11vnc -localhost -display :0'
echo "Connect VNC to localhost:5900"

