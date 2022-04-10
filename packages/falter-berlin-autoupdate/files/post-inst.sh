#!/bin/sh
#

# if autoupdate is not present in crontab, include it.
crontab -l | grep /usr/bin/autoupdate >>/dev/null
if [ $? != 0 ]; then
    # get a fairly random update-time, to protect the servers from DoS. Will be something between 3 and 5 a.m.
    HOUR=$(( ($( dd if=/dev/urandom bs=2 count=1 2>&- | hexdump | if read line; then echo 0x${line#* }; fi ) % 3) + 3))
    MIN=$(( $( dd if=/dev/urandom bs=2 count=1 2>&- | hexdump | if read line; then echo 0x${line#* }; fi ) % 59))
    echo "$MIN $HOUR * * *        /usr/bin/autoupdate" >>/etc/crontabs/root

    /etc/init.d/cron restart
fi
