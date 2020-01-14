# Python Virtual Env


## Documentation
<https://docs.python.org/3/library/venv.html>


#### Install Dependencies
```bash
sudo apt-get install python3-venv
```

#### Virtual Env Creation
```bash
virtualenv tf1_venv
or
python3 -m venv tf2_venv
```

#### Enter in Virtual Env
```bash
cd tf2_venv
source bin/activate
```

#### All executions occur into virtual env
```bash
python ....
```

#### Exit from Virtual Env
```bash
deactivate
```