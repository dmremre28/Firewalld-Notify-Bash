# firewalld
Preventing firewalld from stopping

The infrastructure you're trying to protect has 1000+ servers. They are all reachable from the Internet.
Each server has a firewall running, and only the necessary services are visible from "the outside".
However, people who manage the servers make mistakes from time to time, such as forgetting to
start the firewall after they temporarily stop it. Also, firewalls crash from time to time. Because of
these factors, some of the services/ports which shouldn't be visible to the Internet become visible,
until the problem is discovered and fixed. Obviously, these services could potentially be exploited and
the related servers compromised.

To solve this situation, firstly, a pre-prepared asset list is needed. If there is no asset list, all
server IPs can be scanned with a port scanner. Then, we can verify the ports that should be
open, with the service owners. By that, we can finalize the asset list.

Example:
# nmap 192.168.1.0/24 or nmap -iL destinations.txt (read from file)
PORT STATE SERVICE
22/tcp open ssh
80/tcp open http

Then, with a bash script, the “secure” logs of all server IPs can be monitored and if any user
stops the firewall service on any server, notify mail (Please do not forget to restart the
Firewalld service before logout!) can be sent to the server admins. At the same time, using
this script, we can create an automation to “start” the firewall service automatically if
needed. Finally, this script can be run periodically with a cron job.

Example:
==> /var/log/secure or auth.log⇐
Nov 30 09:09:27 emred sudo: emre : TTY=pts/2 ; PWD=/home/emre ; USER=root ; COMMAND=/bin/systemctl
stop firewalld
