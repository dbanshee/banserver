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

# Instalar dependencias
    pip install -U --user pip six numpy wheel setuptools mock 'future>=0.17.1'
    pip install -U --user keras_applications --no-deps
    pip install -U --user keras_preprocessing --no-deps


# Configuracion de la compilacion
	./configure

Indicara la version necesaria de bazel. Si esta instalada una version no compatible el error puede variar.

#### Descargar Bazel
From (https://github.com/bazelbuild/bazel/releases/tag/0.25.0)
	wget https://github.com/bazelbuild/bazel/releases/download/0.25.0/bazel_0.25.0-linux-x86_64.deb
	sudo dpkg -i bazel_0.25.0-linux-x86_64.deb

	./configure
```
banshee@bantower:~/src/tensorflow$ ./configure
WARNING: --batch mode is deprecated. Please instead explicitly shut down your Bazel server using the command "bazel shutdown".
You have bazel 0.25.0 installed.
Please specify the location of python. [Default is /usr/bin/python]: /usr/bin/python3


Found possible Python library paths:
  /usr/local/lib/python3.7/dist-packages
  /usr/lib/python3/dist-packages
Please input the desired Python library path to use.  Default is [/usr/local/lib/python3.7/dist-packages]

Do you wish to build TensorFlow with XLA JIT support? [Y/n]: 
XLA JIT support will be enabled for TensorFlow.

Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]: 
No OpenCL SYCL support will be enabled for TensorFlow.

Do you wish to build TensorFlow with ROCm support? [y/N]: 
No ROCm support will be enabled for TensorFlow.

Do you wish to build TensorFlow with CUDA support? [y/N]: 
No CUDA support will be enabled for TensorFlow.

Do you wish to download a fresh release of clang? (Experimental) [y/N]: 
Clang will not be downloaded.

Do you wish to build TensorFlow with MPI support? [y/N]: 
No MPI support will be enabled for TensorFlow.

Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native -Wno-sign-compare]: -march=core2 -Wno-sign-compare
```
    
    

#### Compilacion

	bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package

### Pip Package
    ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
