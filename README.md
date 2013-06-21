-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

LMS (Linux Management Server) Administration Scripts

 - maintain a (potentially self updating) inventory of your servers
 - query server inventory to build reports
 - centrally control crontabs and RPM update schedules
 - create status reports and serve basic analytics via apache

Author: Jon Short
Date:   20130621

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

The following administration scripts are designed to be used from a SECURE
central administration server, not from a workstation or any machine with
internet access.

In order for the server inventory to automatically update, servers can be
configured to forward syslog to the LMS system as part of the build.

Once servers are logging to the LMS, reconcile_server_list can be run as a
scheduled task to detect new server logs and add them to the inventory
with a set of default attributes.  The included _conf/rsyslog.conf can be
used as a template for sorting logs by their server name.

Default locations: (can be altered in the scripts to fit your environment)
- utility account user: it-lms (Linux Management Server)
- location of the server inventory: /home/it-lms/servers/linux-server-list
- location of centralized server logs: /logs/hosts/<server_name>

