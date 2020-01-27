#! /bin/bash

#############################################################
# Banshee - 2013
#
# Banfirewall
#############################################################

# Evita Ping desde la red externa.
iptables -A INPUT -p icmp --icmp-type echo-request -s 192.168.1.0/24 -j DROP
iptables -A INPUT -p icmp --icmp-type echo-request -s 192.168.0.0/24 -j DROP


# Evita el acceso al servidor Apache en la red externa.
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 80 -j DROP
iptables -A INPUT -p tcp -s 192.168.0.0/24 --dport 80 -j DROP

# Evita el acceso al servidor SSH en la red externa.
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 22 -j DROP
iptables -A INPUT -p tcp -s 192.168.0.0/24 --dport 22 -j DROP


# Evita el acceso al servidor FTP en la red externa.
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 21 -j DROP
iptables -A INPUT -p tcp -s 192.168.0.0/24 --dport 21 -j DROP


# Evita el acceso al servidor VNC en la red externa.
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 5900 -j DROP
iptables -A INPUT -p tcp -s 192.168.0.0/24 --dport 5900 -j DROP




