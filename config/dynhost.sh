#! /bin/sh
# Mainly inspired by DynHost script given by OVH
# New version by zwindler (zwindler.fr/wordpress)
#
# Initial version was doing  nasty grep/cut on local ppp0 interface
#
# This coulnd't work in a NATed environnement like on ISP boxes
# on private networks.
#
# Also got rid of ipcheck.py thanks to mafiaman42
#
# This script uses curl to get the public IP, and then uses wget
# to update DynHost entry in OVH DNS
#
# Logfile: dynhost.log
#
# CHANGE: "HOST", "LOGIN" and "PASSWORD" to reflect YOUR account variables
SCRIPT_PATH='/srv/dyndns'
IP=`curl http://ifconfig.me/ip`
OLDIP=`dig +short $HOST @$NSSERVER`

if [ "$IP" ]; then
    if [ "$OLDIP" != "$IP" ]; then
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] Dyndns check - Old: ${OLDIP} - New: ${IP} -> ###### Update is needed… ######"
        wget "${ENTRYPOINT}?system=dyndns&hostname=${HOST}&myip=${IP}" --user="${LOGIN}" --password="${PASSWORD}"
        echo -n "$IP" > $SCRIPT_PATH/old.ip
    else
        echo "[`date '+%Y-%m-%d %H:%M:%S'`] Dyndns check - Old: ${OLDIP} - New: ${IP} -> No update required."
    fi
 else
    echo "[`date '+%Y-%m-%d %H:%M:%S'`] Dyndns check - WAN IP not found. Exiting!"
 fi