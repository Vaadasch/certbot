#!/bin/bash

if [ -z "$EMAIL" ]; then 
	echo "Fatal: administrator email address must be specified with the environment variable named 'EMAIL'"; 
	exit 1; 
fi

if [ -z "$DOMAIN_1" ]; then 
	echo "Specify at least one domain in the 'DOMAIN' variable, or multiple domains with 'DOMAIN_1', 'DOMAIN_2', 'DOMAIN_3'..."; 
	echo "The verification file for each domain will be positionned in /var/lib/letsencrypt/DOMAIN_#/";
	exit 1; 
fi

for var in $(printenv | grep ^DOMAIN_[0-9]* | awk -F '=' '{print $1}') ; 
do

	dom=$(eval echo \$$var)
	
	if [ -z "$dom" ] ; then
		echo "Variable $var empty";
	fi
	
	if [ -d 
	
	
done


