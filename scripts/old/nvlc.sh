#!/bin/bash
#
# Banscript - 05/12/2013
#
# Ejecuta vlc cambiando el modo de nvidia a max performance. Espera hasta su finalizacion y restaura el modo.
#
# En la actualidad existe un bug por el cual no se eleva automaticamente este modo al necesitar mas potencia.
# Se produce tearing de video en modo adaptativo.
#

nvidia-settings -a [gpu:0]/GPUPowerMizerMode=1

# Segundo plano con espera de subproceso
#vlc $@ &
#wait $! 


scapedParams=`echo "$@" | sed "s/\ /\\\ /g"` # El fichero puede venir sin los espacios escapados. De momento se estan perdiendo el resto de posibles parametros.
echo "Playing $scapedParams"
vlc "$scapedParams"

nvidia-settings -a [gpu:0]/GPUPowerMizerMode=0
