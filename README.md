Programming and idea by : E2MA3N [Iman Homayouni]
Github : https://github.com/e2ma3n
Email : e2ma3n@Gmail.com
Special tnx to : Mohamad Varmazyar, varmazyar@oslearn.ir
Website : http://OSLearn.ir
License : GPL v3.0
radic v1.0 [checking memory, cpu, disk usages and send email and sms alarm when these where full]


Description :
	This program Written by E2MA3N for monitoring memory, cpu and disk usages On Linux Systems. this is a simple program for Alerting SysAdmins with text message and email in emergency conditions


Dependencies :
	1. whoami 
	2. sleep 
	3. cat 
	4. head 
	5. tail 
	6. cut 
	7. expr 
	8. curl 
	9. mailx
	10. iostat


Install radic v1.0 :
	1. sudo ./install.sh -i


Check radic dependencies :
	1. sudo ./install.sh -c


Install mailx in debian :
	1. sudo apt-get install heirloom-mailx


Istall mailx in centos :
	1. sudo yum install mailx


Install iostat in debian :
	1. sudo apt-get install sysstat


Install iostat in centos :
	1. sudo yum install sysstat


Testing program :
	1. radic --test_mail # plaese see varbose
	2. radic --test_sms # please see verbose


Usage radic v1.0 :
	1. sudo radic --status # for check program's status
	2. sudo radic --start # for start program in background
	3. sudo radic --stop # for stop program service


Uninstall radic v1.0 :
	1. rm -rf /opt/radic_v1/
	2. rm -f /usr/bin/radic


Notes :
	1. you have two choises : start manually or Starting up Script As a daemon
	2. You should run program as root
	3. You should edit config file
	4. this program now is compatible with sms[dot]ir panel


Testes radic v1.0 in :
	1. Debian 8.1.0 64bit netinst, 3.16.0-4-amd64
	2. Centos 6.3 32bit minimal, 2.6.32-279.el6.i686
	3. Ubuntu 14.04 LTS - desktop


CentOS bug - mailx :
	Error : Missing "nss-config-dir" variable.
	Patch : add '-S nss-config-dir=/etc/pki/nssdb/' to mailx's options


Disable send-mail or send-sms :
	1. open /opt/radic_v1/radic-core.sh
	2. delete send-mail or send-sms from line 82 to 91
