#!/usr/bin/env python

import tensorflow as tf

print('TensorFlow version: {}' .format(tf.__version__))
if tf.test.gpu_device_name():
    print('Default GPU Device: {}'.format(tf.test.gpu_device_name()))
else:
   print("Please install GPU version of TF")
