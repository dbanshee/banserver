#! /bin/bash

#
# Banshee - 2020
#
# Mezcla Microfono a otros dispositivos y crea una source PulseAudio.
# Permite utilizar programas de mensajeria agregando sonido adicional,
# 
# Se vuelca Microfono y salida de Jack en interfaces de Loopback previamente configuradas en ~/.asoundrc
# mezclando ambas en un unico dispositivo PCM que se conecta a PulseAudio como una source.
# Es posible asignar este nuevo dispositivo como desde Pavucontrol como entrada.
#
# Detalle de pipeline Alsa en ~/.asoundrc
#


ALSA_MIC_DEVICE='hw:Intel,0' # Built-In Mic

ALSA_LOOP_CH0_CAPTURE=cloopdmix0
ALSA_LOOP_CH1_CAPTURE=cloopdmix1
ALSA_MIXER_PLAYBACK=plugloopmixer_stereo

PULSE_SOURCE_NAME="MicGuitarMixer"
PULSE_SOURCE_DESC=MicGuitarMixer

function abort () {
  # Disable trap. Infinite loop if kill GID.  
  if [ ! -z $SRC_ID ] ; then
    echo "Unloading Pulse Module Source. SRC_ID : ${SRC_ID}"
    pactl unload-module $SRC_ID
  fi

  echo "Ending subprocess" 
  pkill -P $$
  exit 0
}

trap abort SIGTERM SIGKILL SIGINT


# Se vuelca el microfono al canal 0 de Loopback.
echo "Redirecting Mic : $ALSA_MIC_DEVICE to Loopback : $ALSA_LOOP_CH0_CAPTURE"
arecord -c 2 -f S16_LE -r 48000 -D $ALSA_MIC_DEVICE - | aplay -D $ALSA_LOOP_CH0_CAPTURE &

#
# Jack volcará en la interfaz de Loopback el sonido producido a través de un jack client ('jack_out' command)
#
#  alsa_out -j ploop -d cloopdmix0
#
echo "Creating alsa_out connector to Loopback : $ALSA_LOOP_CH1_CAPTURE"
alsa_out -j ploopmixer -d $ALSA_LOOP_CH1_CAPTURE &

# Test redirections: 
#  sox -q -t alsa plugloopmixer_stereo -t wav -b 16 -r48k - | aplay

# Reload PulseAudio to read .asoundrc changes
#  systemctl --user restart pulseaudio
  
echo "Creating Pulse Audio Source"
SRC_ID=$(pactl load-module module-alsa-source source_name=${PULSE_SOURCE_NAME} source_properties=device.description=${PULSE_SOURCE_DESC} device=${ALSA_MIXER_PLAYBACK})
echo "Created Pulse Source Module with Id : ${SRC_ID}"

sleep 2

echo -e "\n\n" 
echo "You can select Source '${PULSE_SOURCE_NAME}' in Pavucontrol as input to Messaging Apps."
echo "Yout can control channels volumes with alsamixer"
echo "Pulse any key to close PulseAudio source ..."
read
abort
