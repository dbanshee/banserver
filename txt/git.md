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

## Problemas

### Solucionar error: server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
https://shakaran.net/blog/2017/06/solucionar-error-server-certificate-verification-failed-cafile/

```bash
GIT_CURL_VERBOSE=1
GIT_CURL_VERBOSE=1 git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg
Clonar en «ffmpeg»...
* Couldn't find host git.ffmpeg.org in the .netrc file; using defaults
* Trying 79.124.17.100...
* TCP_NODELAY set
* Connected to git.ffmpeg.org (79.124.17.100) port 443 (#0)
* found 168 certificates in /etc/ssl/certs/ca-certificates.crt
* found 684 certificates in /etc/ssl/certs
* ALPN, offering http/1.1
* SSL connection using TLS1.2 / ECDHE_RSA_AES_128_GCM_SHA256
* server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
* Curl_http_done: called premature == 1
* Closing connection 0
fatal: unable to access 'https://git.ffmpeg.org/ffmpeg.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
```

Existe una manera rápida y sucia de solucionar el problema que es ignorar el paso de verificar el certificado (ojo, esto implicaría que realmente confías en el sitio que estas ignorando y que si alguien ha reemplazado su certificado de forma maligna, tu asumirías las consecuencias), para ignorar la verificación en GIT:

```bash
$git config --global http.sslverify false
```

O bien puedes usar la variable de entorno:
```bash
$ export GIT_SSL_NO_VERIFY=1
```