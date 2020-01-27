

# Establece la puerta de enlace la red con acceso a Internet
sudo route del default
sudo route add default gw 192.168.1.1


# Se comparte el acceso internet de la interfaz wlan1 a la subred 192.168.15.0
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -o wlan1 -s "192.168.15.0/24" -j MASQUERADE
#sudo iptables -t nat -A POSTROUTING -o wlan0 -s "192.168.15.0/24" -j MASQUERADE
#isudo iptables -t nat -L
