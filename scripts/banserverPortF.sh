#! /bin/bash

#
# Banserver Port Redirection
#
#  SSH            : 22   <--> 10022
#  Apache         : 80   <--> 10080
#  Apache Secure  : 443  <--> 10443
#  VNC            : 5900 <--> 10590
#  RPD            : 9789 <--> 10978
#  Icecast        : 3000 <--> 10300 
#

echo "Banserver Port Forwarding in range 10XXX ..."
ssh -N -4 \
	-L 10022:localhost:22   \
	-L 10080:localhost:80   \
	-L 10443:localhost:443  \
	-L 10590:localhost:5900 \
	-L 10978:localhost:9789 \
	-L 10300:localhost:3000 \
	banshee@localhost
