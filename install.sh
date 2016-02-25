#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Special tnx to : Mohamad Varmazyar, varmazyar@oslearn.ir
# Website : http://OSLearn.ir
# License : GPL v3.0
# radic v1.0 [checking memory, cpu, disk usages and send email and sms alarm when these where full]
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
	[ ! -d /opt/radic_v1/ ] && mkdir -p /opt/radic_v1/ && echo "[+] Directory created" || echo "[-] Error: /opt/radic_v1/ exist"
	sleep 1
	[ ! -f /opt/radic_v1/radic-core.sh ] && cp radic-core.sh /opt/radic_v1/ && chmod 700 /opt/radic_v1/radic-core.sh && echo "[+] radic-core.sh copied" || echo "[-] Error: /opt/radic_v1/radic-core.sh exist"
	sleep 1
	[ ! -f /opt/radic_v1/radic.conf ] && cp radic.conf /opt/radic_v1/ && chmod 700 /opt/radic_v1/radic.conf && echo "[+] radic.conf copied" || echo "[-] Error: /opt/radic_v1/radic.conf exist"
	sleep 1
	[ ! -f /opt/radic_v1/radic.sh ] && cp radic.sh /opt/radic_v1/ && chmod 700 /opt/radic_v1/radic.sh && echo "[+] radic.sh copied" || echo "[-] Error: /opt/radic_v1/radic.sh exist"
	sleep 1
	[ -f /opt/radic_v1/radic.sh ] && ln -s /opt/radic_v1/radic.sh /usr/bin/radic && echo "[+] symbolic link created" || echo "[-] Error: /opt/radic_v1/radic.sh not found"
	sleep 1
	[ ! -d /opt/radic_v1/log/ ] && mkdir -p /opt/radic_v1/log/ && echo "[+] Log Directory created" || echo "[-] /opt/radic_v1/log/ exist"
	sleep 1
	echo "[+] Please see README" ; sleep 0.5
	echo "[+] you have two choises : start manually or Starting up Script As a daemon" ; sleep 0.5
	echo "[!] Warning: You should run program as root" ; sleep 0.5
	echo "[!] Warning: You should edit config file" ; sleep 0.5
	echo "[+] this program now is compatible with sms[dot]ir panel" ; sleep 0.5
	echo "[+] Done"
}

# uninstall program from system
function uninstall_f {
	echo "For uninstall program:"
	echo "	sudo rm -rf /opt/radic_v1"
	echo "	sudo rm -f /usr/bin/radic"
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
