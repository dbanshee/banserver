#! /bin/bash

#
# Banserver Port Redirection
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
DEST_IP=192.168.15.10

echo "Banserver Port Forwarding in range 10XXX ..."
ssh -N -4 \
	-L $LOCAL_IP:10022:$DEST_IP:22    \
	-L $LOCAL_IP:10021:$DEST_IP:21	  \
	-L $LOCAL_IP:10080:$DEST_IP:80    \
	-L $LOCAL_IP:10443:$DEST_IP:443   \
	-L $LOCAL_IP:10590:$DEST_IP:5900  \
	-L $LOCAL_IP:10389:$DEST_IP:3389  \
	-L $LOCAL_IP:10300:$DEST_IP:3000  \
	banshee@$DEST_IP

echo "Closed ports"
