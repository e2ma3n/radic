#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Website : http://OSLearn.ir
# License : GPL v3.0
# radic v1.6 [checking memory, cpu, disk usages and send email and sms alarm when these where full]
# ------------------------------------------------------------------------------------------------ #

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1

# help function
function help_f {
	echo "Usage: "
	echo "	sudo ./install.sh -i [install program]"
	echo "	sudo ./install.sh -u [help to uninstall program]"
	echo "	sudo ./install.sh -c [check dependencies]"
}

# install program on system
function install_f {
	reset
	# print header
	echo '[+] ---------------------------------------------------------------------------------------------------------------------- [+]'
	sleep 1.5
	echo '[+] Radic v1.6'

	sleep 1.5
	echo '[+] This is a simple program for alerting sysadmins with text message and email in emergency conditions'

	sleep 1.5
	echo '[+] Programming and idea by : E2MA3N [Iman Homayouni]'

	sleep 1.5
	echo '[+] http://www.oslearn.ir'

	sleep 1.5
	echo '[+] Tested on all popular linux distributions such as debian 8, CentOS 6 and Ubuntu 14.04 LTS'

	sleep 2.5
	echo -en '[+] please insert "enter" key for continue or press ctrl+c for exit' ; read
	sleep 4

	[ ! -d /opt/radic_v1.6/ ] && mkdir -p /opt/radic_v1.6/ && echo "[+] Main directory created" || echo "[-] Error: /opt/radic_v1.6/ exist"
	sleep 1
	[ ! -f /opt/radic_v1.6/radic.conf ] && cp radic.conf /opt/radic_v1.6/ && chmod 700 /opt/radic_v1.6/radic.conf && echo "[+] radic.conf copied" || echo "[-] Error: /opt/radic_v1.6/radic.conf exist"
	sleep 1
	[ ! -f /opt/radic_v1.6/radic.sh ] && cp radic.sh /opt/radic_v1.6/ && chmod 700 /opt/radic_v1.6/radic.sh && echo "[+] radic.sh copied" || echo "[-] Error: /opt/radic_v1.6/radic.sh exist"
	sleep 1
	[ ! -d /opt/radic_v1.6/log/ ] && mkdir -p /opt/radic_v1.6/log/ && echo "[+] Log directory created" || echo "[-] /opt/radic_v1.6/log/ exist"
	sleep 1
	[ ! -f /opt/radic_v1.6/README.md ] && cp README.md /opt/radic_v1.6/ ; echo '[+] Please see README.md'
	sleep 1

	echo -en '[+] Add /opt/radic_v1.6/radic.sh to /etc/crontab : '

	if [ -f /etc/crontab ] ; then
		cat /etc/crontab | grep '@reboot root /opt/radic_v1.6/radic.sh' &> /dev/null
		if [ "$?" = "0" ] ; then
			echo 'error ! /opt/radic_v1.6/radic.sh is exists in crontab'
		else
			echo '@reboot root /opt/radic_v1.6/radic.sh' >> /etc/crontab
			echo 'done'
		fi
	else
		echo 'error ! cannot access /etc/crontab: No such file or directory'
	fi
	sleep 1

	echo "[!] Warning: You should reboot server" ; sleep 0.5
	echo "[!] Warning: You should edit config file" ; sleep 0.5
	echo '[>] nano /opt/radic_v1.6/radic.conf' ; sleep 0.5
	echo '[+]'
	echo "[+] This program now is compatible with sms[dot]ir panel" ; sleep 0.5
	echo "[+] Finish"
}

# uninstall program from system
function uninstall_f {
	echo "For uninstall program:"
	echo "	sudo rm -rf /opt/radic_v1.6"
	echo "	remove /opt/radic_v1.6/radic.sh from /etc/crontab"
}

# check dependencies on system
function check_f {
	echo "[+] check dependencies on system:  "
	for program in whoami sleep cat head tail cut expr curl mailx iostat
	do
		sleep 0.5
		if [ ! -z `which $program 2> /dev/null` ] ; then
			echo -e "[+] $program found"
		else
			echo -e "[-] Error: $program not found"
		fi
	done
}

case $1 in
	-i) install_f ;;
	-u) uninstall_f ;;
	-c) check_f ;;
	-h) help_f ;;
	*) help_f ;;
esac
