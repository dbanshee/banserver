#! /bin/bash

virtualenv -p /usr/bin/python3 $1


# Instalar paquetes
pip3 install ipython
pip3 install ipykernel


# Default VEnvs
tf1_1.14_cpu
tf1_1.14_gpu
tf2_2.1_gpu
