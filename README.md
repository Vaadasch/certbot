# TL;DR
### Variables

Optionnal :

`-e EMAIL=exemple@domain.com`

Mandatory only if using sitesconf, user readableness string

`-e INSTANCE=Exemple`

Mandatory. periodicity of check, or at start
`-e PERIODICITY=15min|hourly|daily|...|SPAWN`
List of the servernames, Mandatory only if sitesconf not mounted or empty
`-e SERVERNAMES=exemple.domain.com,exemple2.domain.com`
Mandatory only if using sitesconf, keyword to select the ssl protected vhosts
`-e SSL_FLAG=server_ssl.conf`
Mandatory only if using sitesconf, how to find servername in configuration files
`-e SERVER=apache|nginx`
### Volumes
Directory where the new certificates are copied. Optionnal, but what the point otherwise?
```-v /asyouwant/certs:/certs```
directory where you have your servernames config files, 1 file per servername, do not symlink
```-v /sites-configuartions:/sitesconf:ro```
Mandatory, directory to serve the challenges
```-v /path/servername/.well-known/acme-challenge:/challenge/.well-known/acme-challenge```
### Test
Hidden variable
```-e TEST=0|FALSE|WhatEver|SERVERNAMES```

# certbot

This container aim to generate certificates with Let's Encrypt with easy deployment through docker structures

The generated certificate will be copied in the `/certs` dir.
If previous certificates files are present in this dir, it create a new directory `YYYY.MM.dd` to backup these files.

The recuperation of these certificates files is at your conveinence. 
IE mounting `/certs` in a volume or a bind

If you need to generate certificates for more servernames than one container can support, make more containers from this image !



# Why that ?
I wanted to separate the certificate generation from my minimalist nginx container. One container for nginx, one container for php, one for sql, why would I install certbot inside my nginx container?

That plus the fact that I like to control it. It is said that certbot can modify itself the nginx configuration. What? How that? No explaination? 
Then no.

I know, it's silly.
 
# What's needed

The directory `/challenge/.well-known/acme-challenge` need to be binded for it need to be served by your webserver at 
http(s?)://example.domain.com/.well-known/acme-challenge/
Each of your sites need to serve this directory.

Either the following need to be set (more description below): 
 - SERVERNAMES variable, comma separated if multiple
 - `/sitesconf` volume targeting the folder with the files of yours vhosts configuration.
	In this case, INSTANCE, SERVER et SSL_FLAG variables need to be set too. 
	Hopefully, you have only one server by file. If not, you're doing it wrong.
	
The PERIODICITY variable need to be set. Either the `15min`, `hourly`, `daily`, `weekly` or 
`monthly` of the `/etc/periodicity` subirectory.
It is possible to set this variable	at `SPAWN` or `CREATE` (either way) to generate the certificates at the start of the
container then exit. A way to not have this container up and running all the time.

If you're using Nginx, it need to be reload after certificate renewal. 
As LE renew the certificate if it expire in less than 4 days, I've set up a daily cron reload.
You may have other options depending on what you're doing.
	
# SERVERNAMES or SitesConfiguration

Using SERVERNAMES variable is easy. Set up with the servers names you need to generate certificate and you're on the go.
But you'll need to update this value every new server

Using the `/sitesconf` volume binding, the container will read the files to find :
 - if the server is set with ssl, based on the presence of the `SSL_FLAG` word (or line) in the file
 - the name with the `server_name` (nginx) or `ServerName` (apache) line. The selection is set with SERVER variable.

The `/sitesconf` need to be binded to the directory where you put the files of your servers. No need to write, only RO so you're safe.
You need to have only one server by file : one vhost for apache or one server block for nginx.
Moreover, i suggest you only have server files in this directory.

Sadly, you need to have full text files in this directory. 
So the symlink usage of sites-available/sites-enabled will not work (or maybe it will thanks to some obscure fonctionnality of docker ?)
I do not have this tested on apache, only nginx. But contributions are welcome.

# What do I do
The `/.well-known/acme-challenge/` is some folder where my nginx specifically. No need of the binded directory to be named .well-known/acme-challenge. It juste need to be SERVED by that name.

I use a "generic" file `server_ssl.conf` among my https servers. That's why my SSL_FLAG is that name. You can use `ssl_certificate_key` if you write it in each server file.

# Tests
There is a "hidden" (as not in the Dockerfile) env variable `TEST` which can be set to whatever you like to generate `--test-cert` (or staging) certificates.
To prevent errors, 0 or FALSE will do reals certificates.
To force the use of SERVERNAMES variable in tests, set TEST to SERVERNAMES (I don't think that's needed for real environment)

Oh, last thing. If you set periodicity and need to see immediatly what's what, just execute once the /wrap/script.sh.

# Exemples
### Minimalist 
```
docker run 	-e SERVERNAMES=exemple.domain.com \
		-e PERIODICITY=SPAWN 	\
		-v /MyCerts:/certs 	\
		-v /myDir/forLE/validation:/challenge  \
		vaadasch/certbot
```
### Full nginx
```
docker run	-e EMAIL=exemple@domain.com \
		-e INSTANCE=Exemple \
		-e PERIODICITY=daily \
		-e SSL_FLAG=server_ssl.conf \
		-v /MyCerts:/certs \
		-v /myNginx/sites:/sitesconf:ro	\
		-v /myDir/forLE/validation:/challenge/.well-known/acme-challenge \
		vaadasch/certbot		
```
