#!/bin/ash

if [ -z "$EMAIL" ] ; then
	mailArg="--register-unsafely-without-email"
else 
	mailArg="--email $EMAIL"
fi

if [ ! -d "/sitesconf" -o -z "$(ls -A /sitesconf)" ]; then

	if [ -z "$SERVERNAMES" ]; then 
		echo "ERROR : No configuration server file detected nor SERVERNAMES variable"
		echo "Specify the servernames in the 'SERVERNAMES' variable, comma separated"; 
		exit 1; 
	fi
	
	[ -z "$INSTANCE" ] && INSTANCE=$( echo $SERVERNAMES | awk -F ',' '{print $1}')

else
	SERVERNAMES=$(python /wrap/getSites.py)
fi

certbot certonly -n --test-cert --agree-tos $mailArg --cert-name $INSTANCE --webroot -w /challenge -d $SERVERNAMES

python /wrap/moveCerts.py
