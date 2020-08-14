#! /bin/bash

#
# Banshee - 2020
#
# Mezcla Microfono a otros dispositivos y crea una source PulseAudio.
# Permite utilizar programas de mensajeria agregando sonido adicional,
# 
# Volcando en la interfaz de Loopback es posible agregar mezclas provenientes de Jack.
#


#
# Metodo 1
# 
# Mezclar fuentes de sonido en Alsa y crear una unica source PulseAudio.
#
# ~/.asoundrc
#
# pcm.both {
#    type multi
#
#    # Fuente 1
#    #slaves.a.pcm "hw:PCH,0"         # Mic
#    slaves.a.pcm "hw:Loopback,0,0"  
#
#    # Fuente 2
#    slaves.b.pcm "hw:Loopback,0,1"   # Loopback from Jack
#    slaves.a.channels 2
#    slaves.b.channels 2
#
#    bindings.0 { slave a; channel 0; }
#    bindings.1 { slave a; channel 1; }
#    bindings.2 { slave b; channel 0; }
#    bindings.3 { slave b; channel 1; }
#}
#
# Reload PulseAudio to read .asoundrc changes
#  systemctl --user restart pulseaudio
#  

set -x
ALSA_DEVICE="micmixer"
PULSE_SRC_DESC="CustomSource"

SRC_ID=$(pactl load-module module-alsa-source source_name="Both" source_properties=device.description=CustomMix device=${ALSA_DEVICE})

echo "Pulse any key to close PulseAudio source"
read
pactl unload-module $SRC_ID

