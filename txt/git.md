# Git Command Sheet


Show remote url
```bash
git config --get remote.origin.url
```

Set remote url
```bash
git remote set-url origin https://github.com/USERNAME/REPOSITORY.git
```


## Git HTTP

Configurar en Apache: **git-http-backend**
https://git-scm.com/book/en/v2/Git-on-the-Server-Smart-HTTP
https://git-scm.com/docs/git-http-backend

Agregar usuarios
```bash
sudo mkdir /srv/git
sudo chgrp -R www-data /srv/git
sudo htpasswd -c /srv/git/.htpasswd banshee
```

Configurar carpetas en /usr/local/git-server con usuarios y grupos de linux

# Configuracion de Apache
Codigo banserver