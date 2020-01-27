#! /bin/bash
#
# nvidia-powermizer-switcher - 05/12/2013
#


echo " 
 Banshee  - 2013
 nvidia PowerMizer Switcher
 
   tested on nvidia-settings (310.44)
   running `nvidia-settings -v | grep version`
   
"

pwState=$(nvidia-settings -q [gpu:0]/GPUPowerMizerMode | grep -oP "Attribute 'GPUPowerMizerMode'.+gpu.*\K()[^.]+")
if [ "$pwState" == "0" ] ; then
  echo "    GPUPowerMizer Current Mode : 0. Adaptative Mode."
else
  echo "    GPUPowerMizer Current Mode : 1. Maximum Performance Mode."
fi

numParams=$#

if [ $numParams == 1 ] ; then
  if [ "$1" == "0" ] ; then
    pwState="1"
  elif [ "$1" == "1" ] ; then
    pwState="0"
  elif [ "$1" == "x" ] ; then
    echo " Redirecting output to Xterm."
    xterm -e "nvidia-powermizer-switcher.sh;sleep 5"
    exit
  elif [ "$1" == "-h" ] ; then
    echo "  
    Usage Help 
       nvidia-powermizer-switcher
         <mode> omitted. Switch mode.
         <mode>=x  Switch mode with XTerm output.
         <mode>=0  Set PowerMizer to Adaptative Mode.
         <mode>=1  Set PowerMizer to Maximum Performance Mode.
     "
       
    exit
  else
    echo -e "\n  Usage Error. See -h help option."
  exit
  fi
elif [ $numParams -gt 1 ] ; then
  echo -e "\n  Usage Error. See -h help option."
  exit
fi


if [ "$pwState" == "1" ] ; then
  echo "     Switching OFF ..."
  nvidia-settings -a [gpu:0]/GPUPowerMizerMode=0
  echo -e "\n     CURRENT STATUS : ADAPTATIVE\n\n"
else
  echo "     Switching ON ..."
  nvidia-settings -a [gpu:0]/GPUPowerMizerMode=1

  echo -e "\n     CURRENT STATUS : MAXIMUM PERFORMANCE\n\n"
fi
exit 0



