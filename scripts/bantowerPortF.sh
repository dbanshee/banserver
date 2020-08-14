#! /bin/bash

#
# Bantower Port Redirection
#
#  SSH            : 22   <--> 10022
#  FTP            : 21   <--> 10021
#  Apache         : 80   <--> 10080
#  Apache Secure  : 443  <--> 10443
#  VNC            : 5900 <--> 10590
#  RPD            : 3389 <--> 10389
#  Icecast        : 3000 <--> 10300 
#

LOCAL_IP=0.0.0.0
DEST_IP=192.168.15.101

echo "Banserver Port Forwarding in range 10XXX ..."
ssh -N -4 \
	-L $LOCAL_IP:11022:$DEST_IP:22    \
	-L $LOCAL_IP:11021:$DEST_IP:21	  \
	-L $LOCAL_IP:11080:$DEST_IP:80    \
	-L $LOCAL_IP:11443:$DEST_IP:443   \
	-L $LOCAL_IP:11590:$DEST_IP:5900  \
	-L $LOCAL_IP:11389:$DEST_IP:3389  \
	-L $LOCAL_IP:11300:$DEST_IP:3000  \
	banshee@$DEST_IP

echo "Closed ports"
