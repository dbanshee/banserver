#! /bin/bash

DEFAULT_SOCKS5_PORT=5555
DEFAULT_SSH_SERVER="banshee@banserver.bansheerocks.com"
DEFAULT_SSH_SERVER_PORT=9722

nArgs=$#
if [ $nArgs == 3 ] ; then
  SOCKS5_PORT=$1
  SSH_SERVER=$2
  SSH_SERVER_PORT=$3
else
  echo "Input parameters <SOCKS5_PORT> <SSH_SERVER> <SSH_SERVER_PORT> not provided. Using Defaults."
  SOCKS5_PORT=$DEFAULT_SOCKS5_PORT
  SSH_SERVER=$DEFAULT_SSH_SERVER
  SSH_SERVER_PORT=$DEFAULT_SSH_SERVER_PORT
fi

echo "Opening SOCKS5 Port: $SOCKS5_PORT on $SSH_SERVER port $SSH_SERVER_PORT"

# -D 5555: open a SOCKS proxy on local port :1337. If that port is taken, try a different port number. If you want to open multiple SOCKS proxies to multiple endpoints, choose a different port for each one.
# -C: compress data in the tunnel, save bandwidth
# -q: quiet mode, don’t output anything locally
# -N: do not execute remote commands, useful for just forwarding ports
# -f: fork into a background command
SSH_CMD="ssh -D $SOCKS5_PORT -f -q -C -N -p $SSH_SERVER_PORT $SSH_SERVER"
eval $SSH_CMD
pgrep -f "${SSH_CMD}"
