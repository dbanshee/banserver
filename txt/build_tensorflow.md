# Compilar TensorFlow Source

A partir de la version 1.5 los binarios oficiales son compilados con extensiones de CPU AVX.
El interprete Python se cerrara elevando un core dumped al importar tensorflow
Es necesario compilar los fuentes con soporte nativo para la arquitectura donde se vaya a ejecutar.

https://tech.amikelive.com/node-887/how-to-resolve-error-illegal-instruction-core-dumped-when-running-import-tensorflow-in-a-python-program/

#### Instrucciones descargar desde source
(https://www.tensorflow.org/install/source)


#### Descargar Source
	git clone https://github.com/tensorflow/tensorflow
	cd tensorflow
	git co v1.14.0

# Configuracion de la compilacion
	./configure

Indicara la version necesaria de bazel. Si esta instalada una version no compatible el error puede variar.

#### Descargar Bazel
From (https://github.com/bazelbuild/bazel/releases/tag/0.25.0)
	wget https://github.com/bazelbuild/bazel/releases/download/0.25.0/bazel_0.25.0-linux-x86_64.deb
	sudo dpkg -i bazel_0.25.0-linux-x86_64.deb

	./configure

#### Compilacion
	bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package

