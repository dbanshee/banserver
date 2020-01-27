#############################################################
# Banshee - 2013
#
# Script para compartir internet a traves de adaptador wifi
#############################################################


IIFACE="wlan0"
BRIDGE="wlan1"

BRIDGE_NET="192.168.15.255"
BRIDGE_IP="192.168.15.1"
BRIDGE_NETMASK="255.255.255.0"
BRIDGE_BROADCAST="192.168.15.255"

# Se levanta la interfaz inalambrica
ifconfig $BRIDGE up

# Se asigna configuracion de red
ifconfig $BRIDGE $BRIDGE_IP netmask $BRIDGE_NETMASK broadcast $BRIDGE_BROADCAST

# Se levanta el daemon hostapd
/etc/init.d/init.disabled/hostapd restart

# Se levanta el daemon DHCP
service isc-dhcp-server restart

# Iptables

# Se limpia la tabla nat
iptables -t nat -F

# Se añade regla NAT de puente entre redes
iptables -t nat -A POSTROUTING -o $IIFACE -s "$BRIDGE_NET/24" -j MASQUERADE


#################################
# Temporal - mover a otro script
#################################

# Evita el acceso a la interfaz web de KTorrent en la red vecinal
#iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 8080 -j DROP
#iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 6881 -j DROP

