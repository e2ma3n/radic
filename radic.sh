#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Special tnx to : Mohamad Varmazyar, varmazyar@oslearn.ir
# Website : http://OSLearn.ir
# License : GPL v3.0
# radic v1.5 [checking memory, cpu, disk usages and send email and sms alarm when these where full]
# ------------------------------------------------------------------------------------------------ #

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1

# check config file
[ ! -f /opt/radic_v1.5/radic.conf ] && echo -e "\e[91m[-]\e[0m Error: can not find config file" && exit 1

# check radic-core.sh
[ ! -f /opt/radic_v1.5/radic-core.sh ] && echo -e "\e[91m[-]\e[0m Error: can not find radic-core.sh" && exit 1

# help function
function usage_f {
	echo "Usage: "
	echo "	radic --start"
	echo "	radic --stop"
	echo "	radic --status"
	echo "	radic --test_mail"
	echo "	radic --test_sms"
}

function start_f {
	pgrep -f radic-core.sh &> /dev/null
	if [ "$?" = "0" ] ; then
		echo -e "\e[91m[-]\e[0m Error: radic service is active"
	else
		/opt/radic_v1.5/radic-core.sh &> /dev/null &
		[ "$?" = "0" ] && echo "[+] Starting radic ..." && sleep 2 && echo -e "\e[92m[+]\e[0m Ok" || echo -e "\e[91m[-]\e[0m Error: radic service not started"
	fi
}

function stop_f {
	kill `pgrep -f radic-core.sh` &> /dev/null
	[ "$?" = "0" ] && echo "[+] Stoping radic ..." && sleep 2 && echo -e "\e[92m[+]\e[0m Ok" || echo -e "\e[91m[-]\e[0m Error: radic service is inactive"
}

function status_f {
	pgrep -f radic-core.sh &> /dev/null
        if [ "$?" = "0" ] ; then
		echo -e "\e[92m[+]\e[0m radic service is active"
	else
		echo -e "\e[91m[-]\e[0m radic service is inactive"
	fi
}

function test_mail {
	t1=`echo -n '20' ; date '+%y/%m/%d'`
	t2=`echo -n 'DATE: 20' ; date '+%y/%m/%d TIME: %H:%M:%S'`
	smtp_srv=`cat /opt/radic_v1.5/radic.conf | head -n 27 | tail -n 1 | cut -d = -f 2`
	smtp_user=`cat /opt/radic_v1.5/radic.conf | head -n 29 | tail -n 1 | cut -d = -f 2`
	smtp_pass=`cat /opt/radic_v1.5/radic.conf | head -n 31 | tail -n 1 | cut -d = -f 2`
	mail_to=`cat /opt/radic_v1.5/radic.conf | head -n 33 | tail -n 1 | cut -d = -f 2`
	IP=127.0.0.1
	CPU_mail=Testing
	RAM_mail=Testing
	DISK_mail=Testing
	text=`echo "$t2" ; echo "IP : $IP" ; echo $CPU_mail ; echo $RAM_mail ; echo $DISK_mail`
	echo "$text" | mailx -v -r "$smtp_user" -s "Radic - $t1" -S smtp=$smtp_srv -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$smtp_user -S smtp-auth-password=$smtp_pass -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb/ $mail_to
}

function test_sms {
	Suser=`cat /opt/radic_v1.5/radic.conf | head -n 9 | tail -n 1 | cut -d = -f 2`
	Spass=`cat /opt/radic_v1.5/radic.conf | head -n 11 | tail -n 1 | cut -d = -f 2`
	Sto=`cat /opt/radic_v1.5/radic.conf | head -n 13 | tail -n 1 | cut -d = -f 2`
	Sline=`cat /opt/radic_v1.5/radic.conf | head -n 15 | tail -n 1 | cut -d = -f 2`
	msg="Radic_testing"
	curl "http://n.sms.ir/SendMessage.ashx?text=$msg&lineno=$Sline&to=$Sto&user=$Suser&pass=$Spass" ; echo
}

case $1 in
	--start) start_f ;;
	--stop) stop_f ;;
	--status) status_f ;;
	--test_mail) test_mail ;;
	--test_sms) test_sms ;;
	*) usage_f ;;
esac
