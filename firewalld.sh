#!/bin/bash
host=$(hostname)
fw_status_log="var/tmp/fw_is_not_running"
fw_log_file="/var/tmp/fw_log_file"
max_duration=120
systemctl status firewalld > $fw_log_file
if grep -i "Active: inactive (dead)" $fw_log_file; then
secureloguser=`cat /var/log/secure | grep -i "COMMAND=/bin/systemctl stop firewalld" | tail -1 | awk '{print $6}'`
if [ -f "${fw_status_log}" ]; then
duration=$(expr `date +%s` - `stat -c %Y $fw_status_log`)
if (( $max_duration < $duration )); then
#echo "Firewall service started automatically because you exceeded the time given to you!"
systemctl start firewalld
fi
else
touch $fw_status_log
#echo "Firewall service stopped!" | mail -s "Firewall service has stopped by $secureloguser!" -r
"$host@adjust.com" admin@adjust.com
fi
else
rm -rf $fw_status_log
fi
