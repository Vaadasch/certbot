#!/bin/ash

# If email is not set, use unsafely regsiter
if [ -z "$EMAIL" ] ; then
	mailArg="--register-unsafely-without-email"
else 
	# Or use Email
	mailArg="--email $EMAIL"
fi

# If the sitesconf directory doesn't exist or is empty
if [ ! -d "/sitesconf" -o -z "$(ls -A /sitesconf)" ]; then
	# And if SERVERNAME var is empty, we throw an error
	if [ -z "$SERVERNAMES" ]; then 
		echo "ERROR : No configuration server file detected nor SERVERNAMES variable"
		echo "Specify the servernames in the 'SERVERNAMES' variable, comma separated"; 
		exit 1; 
	fi
	# If instance variable is not set, we select the first servername of string SERVERNAME
	[ -z "$INSTANCE" ] && INSTANCE=$( echo $SERVERNAMES | awk -F ',' '{print $1}')

else  # We use the configurations files to find the servernames
	SERVERNAMES=$(python /wrap/getSites.py)
fi

# If TEST is set, we use --test-cert. Only if it's not set to 0 or FALSE
if [ ! -z "$TEST" ] ; then
	if [ "$TEST" = "0" -o "$TEST" = "FALSE" ] ; then TEST=""
	else 
		TEST="--test-cert"
	fi
fi

# Getting the certs
certbot certonly -n --agree-tos $TEST $mailArg --cert-name $INSTANCE --webroot -w /challenge -d $SERVERNAMES

# Copy it safely in the /certs directory
python /wrap/moveCerts.py
