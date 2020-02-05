# Jupyter Hub Installation

## Documentation
Jupyter Tricks
<https://www.dataquest.io/blog/jupyter-notebook-tips-tricks-shortcuts/>

- **Instalacion Jupyter Lab**

```bash
sudo pip install jupyterlab
jupyter kernelspec list
```

- **Instalacion IPython3**\
http://ipython.org/ipython-doc/dev/interactive/tutorial.html#magic-functions>
\

```bash
sudo apt-get install ipython3
sudo pip3 install ipykernel
jupyter kernelspec list
```


- **Ejecucion**
```bash
jupyter notebook
jupyter lab
```


- **Aditional kernels (Python2)**
    - **Python2**
```bash
sudo pip install ipykernel 
```

- **Cell Time with %%time*
```bash
sudo pip3 install ipython-autotime
```
    - **Java**
```bash
wget https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip
sudo python3 install.py --sys-prefix
wget https://github.com/SpencerPark/IJava/archive/v1.3.0.zip
unzip v1.3.0.zip
chmod u+x gradlew
```


- **Isolated Virtual Env (Instrucciones incompletas)**\
<https://jupyterhub.readthedocs.io/en/stable/reference/config-user-env.html>
<https://janakiev.com/blog/jupyter-virtual-envs/>
\

```bash
sudo pip3 install --user virtualenv
#pip install --user ipykernel
source python3_virtualenv/bin/activate
pip install ipykernel
deactivate
```

```bash
python3 -m ipykernel install --user --name=python3_virtualenv/
2324  python3 -m ipykernel install --user --name=python3_virtualenv
2325  jupyter kernelspec list
2327  cat /home/banshee/.local/share/jupyter/kernels/python3_virtualenv/kernel.json 
2331  jupyter kernelspec list
2334  cat /home/banshee/.local/share/jupyter/kernels/python3_virtualenv/kernel.json 
336  vim /home/banshee/.local/share/jupyter/kernels/python3_virtualenv/kernel.json
```

Se creo mal el fichero del kernel. Apuntaba python3 en lugar del al virtualenv creado. Se modifico el fichero a mano


## JupyterLab en JupyterHub

```bash
sudo pip3 install jupyterlab
sudo jupyter labextension install @jupyterlab/hub-extension
```

```
# File Config (jupyterhub_config.py)
-- set c.Spawner.default_url = '/lab' in  
```

### Librerias Python Adicionales

- Instalacion code autocompletion
```bash
sudo pip3 install pyreadline
```


- Pillow
```bash
sudo pip3 install 
```

- Python Extensions
<https://github.com/cpcloud/ipython-autotime>


### GitLab Extension
- List Extensions:
```bash
jupyter labextension list
```


- Html Extension
```bash
sudo jupyter labextension install @mflevine/jupyterlab_html
```


- Git Extension
```bash
sudo pip install --upgrade jupyterlab-git
sudo jupyter lab build
```


- GDrive Extension
```bash
sudo jupyter labextension install @jupyterlab/google-drive
```


- SQL Extension
```bash
sudo pip install jupyterlab_sql
sudo jupyter serverextension enable jupyterlab_sql --py --sys-prefix
sudo jupyter lab build
```


- Table of Contents
```bash
sudo jupyter labextension install @jupyterlab/toc
```


- Data Registry
```bash
sudo jupyter labextension install @jupyterlab/dataregistry-extension
```


- Jump To Definition
```bash
sudo jupyter labextension install @krassowski/jupyterlab_go_to_definition -- jupyter labextension update @krassowski/jupyterlab_go_to_definition
```


- Variable Inspector
```bash
sudo jupyter labextension install @lckr/jupyterlab_variableinspector
```

- TensorBoard
```bash
jupyter labextension install jupyterlab_tensorboard
```

- GitHub
```bash
jupyter labextension install @jupyterlab/github
```


## Remote SSH Kernel
<https://stackoverflow.com/questions/29037211/how-do-i-add-a-kernel-on-a-remote-machine-in-ipython-jupyter-notebook>
<https://pypi.org/project/remote_ikernel/>
<https://stackoverflow.com/questions/55730569/remote-jupyter-kernel-different-virtual-environment>
```bash
sudo pip3 install remote_ikernel
remote_ikernel manage --add --kernel_cmd="ipython kernel -f {connection_file}" --name="Remote Python 3" --cpus=2 --interface=ssh --host=banshee@bantower
ipython kernelspec list
# Add SSH Credentials
ssh-keygen 
ssh-copy-id banshee@bantower
```



## Remote SSH Virtual Envs
Investigar como iniciar remotamente un virtual env
ikernel profiles
<https://stackoverflow.com/questions/20327621/calling-ipython-from-a-virtualenv>
```python
ipython profile create sshjupyter
```

