#!/bin/ash

if [ "$PERIODICITY" = "SPAWN" -o "$PERIODICITY" = "CREATE" ] ; then 
	/bin/ash /wrap/script.sh 
	exit
else

	if [ ! -x /etc/periodic/$PERIODICITY/renew ] ; then
		echo "/bin/ash /wrap/script.sh" > /etc/periodic/$PERIODICITY/renew
		chmod +x /etc/periodic/$PERIODICITY/renew
	fi
	/bin/ash
	
fi

