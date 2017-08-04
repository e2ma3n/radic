#! /bin/bash
# Programming and idea by : E2MA3N [Iman Homayouni]
# Github : https://github.com/e2ma3n
# Email : e2ma3n@Gmail.com
# Special tnx to : Mohamad Varmazyar, varmazyar@oslearn.ir
# Website : http://OSLearn.ir
# License : GPL v3.0
# radic v1.6 [checking memory, cpu, disk usages and send email and sms alarm when these where full]
# ------------------------------------------------------------------------------------------------ #

# check root privilege
[ "`whoami`" != "root" ] && echo -e '[-] Please use root user or sudo' && exit 1

# help function
function usage_f {
	echo "Usage: "
	echo "	./radic"
	echo "	./radic --test_mail"
	echo "	./radic --test_sms"
}

function test_mail {
	t2=`date +'%e %b %Y - %H:%M:%S - %Z'`

	smtp_srv=`cat /opt/radic_v1.6/radic.conf | head -n 27 | tail -n 1 | cut -d = -f 2`
	smtp_user=`cat /opt/radic_v1.6/radic.conf | head -n 29 | tail -n 1 | cut -d = -f 2`
	smtp_pass=`cat /opt/radic_v1.6/radic.conf | head -n 31 | tail -n 1 | cut -d = -f 2`
	mail_to=`cat /opt/radic_v1.6/radic.conf | head -n 33 | tail -n 1 | cut -d = -f 2`
	IP=Testing
	CPU_mail=Testing
	RAM_mail=Testing
	DISK_mail=Testing
	text=`echo "$t2" ; echo "IP : $IP" ; echo $CPU_mail ; echo $RAM_mail ; echo $DISK_mail`
	echo "$text" | mailx -v -r "$smtp_user" -s "Radic | $IP" -S smtp=$smtp_srv -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$smtp_user -S smtp-auth-password=$smtp_pass -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb/ $mail_to
}

function test_sms {
	Suser=`cat /opt/radic_v1.6/radic.conf | head -n 9 | tail -n 1 | cut -d = -f 2`
	Spass=`cat /opt/radic_v1.6/radic.conf | head -n 11 | tail -n 1 | cut -d = -f 2`
	Sto=`cat /opt/radic_v1.6/radic.conf | head -n 13 | tail -n 1 | cut -d = -f 2`
	Sline=`cat /opt/radic_v1.6/radic.conf | head -n 15 | tail -n 1 | cut -d = -f 2`
	msg="Radic_testing"
	curl "http://n.sms.ir/SendMessage.ashx?text=$msg&lineno=$Sline&to=$Sto&user=$Suser&pass=$Spass" ; echo
}


if [ ! -z "$1" ] ; then
	[ ! -f /opt/radic_v1.6/radic.conf ] && echo '[-] Error : cannot access /opt/radic_v1.6/radic.conf: No such file or directory' && exit 1
	case $1 in
		--test_mail) test_mail ;;
		--test_sms) test_sms ;;
		*) usage_f ;;
	esac
else

	echo '[+] starting program ...' ; sleep 0.5
	echo '[+] Also you can run ./radic --help'

	disk_check=0
	for (( ;; )) ; do

		[ ! -f /opt/radic_v1.6/radic.conf ] && echo '[-] Error : cannot access /opt/radic_v1.6/radic.conf: No such file or directory' && exit 1

		Suser=`cat /opt/radic_v1.6/radic.conf | head -n 9 | tail -n 1 | cut -d = -f 2`
		Spass=`cat /opt/radic_v1.6/radic.conf | head -n 11 | tail -n 1 | cut -d = -f 2`
		Sto=`cat /opt/radic_v1.6/radic.conf | head -n 13 | tail -n 1 | cut -d = -f 2`
		Sline=`cat /opt/radic_v1.6/radic.conf | head -n 15 | tail -n 1 | cut -d = -f 2`
		IP=`cat /opt/radic_v1.6/radic.conf | head -n 17 | tail -n 1 | cut -d = -f 2`
		cmore=`cat /opt/radic_v1.6/radic.conf | head -n 19 | tail -n 1 | cut -d = -f 2`
		rmore=`cat /opt/radic_v1.6/radic.conf | head -n 21 | tail -n 1 | cut -d = -f 2`
		dmore=`cat /opt/radic_v1.6/radic.conf | head -n 23 | tail -n 1 | cut -d = -f 2`
		delay=`cat /opt/radic_v1.6/radic.conf | head -n 25 | tail -n 1 | cut -d = -f 2`
		smtp_srv=`cat /opt/radic_v1.6/radic.conf | head -n 27 | tail -n 1 | cut -d = -f 2`
		smtp_user=`cat /opt/radic_v1.6/radic.conf | head -n 29 | tail -n 1 | cut -d = -f 2`
		smtp_pass=`cat /opt/radic_v1.6/radic.conf | head -n 31 | tail -n 1 | cut -d = -f 2`
		mail_to=`cat /opt/radic_v1.6/radic.conf | head -n 33 | tail -n 1 | cut -d = -f 2`

		cpu_sum=0 ; ram_sum=0
		cpu_check=0 ; ram_check=0
		unset CPU ; unset RAM ; unset DISK
		unset CPU_mail ; unset RAM_mail ; unset DISK_mail

		for (( i=0 ; i < 5 ; i++ )) ; do

			# check cpu usage
			cpun[$i]=`iostat | grep -A1 '%idle' | tr " " : | tr -s : | cut -d : -f 7 | tail -n1 | cut -d . -f 1`
			cpun[$i]=`expr 100 - ${cpun[$i]}`
			[ "$cmore" -lt "${cpun[$i]}" ] && let cpu_check+=1 && cpu_sum=`expr $cpu_sum + ${cpun[$i]}`

			# check ram usage
			echo 3 > /proc/sys/vm/drop_caches
			ramn[$i]=`free -m | grep Mem | tr -s " " : | cut -d : -f 3`
			[ "$rmore" -lt "${ramn[$i]}" ] && let ram_check+=1 && ram_sum=`expr $ram_sum + ${ramn[$i]}`

			sleep $delay
		done

		# check disk usage
		diskn=`df -T / | tail -n1 | tr -s " " . | cut -d . -f 6 | tr -d '%'`
		[ "$dmore" -lt  "$diskn" ] && DISK="%0ADISK%20usage%20$diskn%" && DISK_mail="DISK usage $diskn%" && let disk_check+=1


		[ "2" -lt "$cpu_check" ] && cpun=`expr $cpu_sum / $cpu_check` && CPU="%0ACPU%20usage%20$cpun%" && CPU_mail="CPU usage $cpun%"

		[ "2" -lt "$ram_check" ] && ramn=`expr $ram_sum / $ram_check` && RAM="%0ARAM%20usage%20${ramn}MB" && RAM_mail="RAM usage ${ramn}MB"


		# send sms function
		function send-sms {
			msg="IP=$IP$CPU$RAM$DISK"
			out=`curl "http://n.sms.ir/SendMessage.ashx?text=$msg&lineno=$Sline&to=$Sto&user=$Suser&pass=$Spass"`
			if [ "$out" != "ok" ] ; then
				echo -n "[-] " >> /opt/radic_v1.6/log/errors.log ; date +'%e %b %Y - %H:%M:%S - %Z' >> /opt/radic_v1.6/log/errors.log
				echo "[-] Error: we have problem on send-sms" >> /opt/radic_v1.6/log/errors.log
				echo "[-] ------------------------------------------------ [-]" >> /opt/radic_v1.6/log/errors.log
			fi
		}

		# send mail function
		function send-mail {
			t2=`date +'%e %b %Y - %H:%M:%S - %Z'`

			text=`echo "Date : $t2" ; echo "IP : $IP" ; echo $CPU_mail ; echo $RAM_mail ; echo $DISK_mail`
			echo "$text" | mailx -v -r "$smtp_user" -s "Radic | $IP" -S smtp=$smtp_srv -S smtp-use-starttls -S smtp-auth=login -S smtp-auth-user=$smtp_user -S smtp-auth-password=$smtp_pass -S ssl-verify=ignore -S nss-config-dir=/etc/pki/nssdb/ $mail_to &> /dev/null
			if [ "$?" != "0" ] ; then
				echo -n "[-] " >> /opt/radic_v1.6/log/errors.log ; date +'%e %b %Y - %H:%M:%S - %Z' >> /opt/radic_v1.6/log/errors.log
				echo "[-] Error: we have problem on send-mail" >> /opt/radic_v1.6/log/errors.log
				echo "[-] ------------------------------------------------ [-]" >> /opt/radic_v1.6/log/errors.log
			fi
		}

		if [ -z "$CPU" ] ; then
			if [ -z "$RAM" ] ; then
				if [ "$disk_check" = "1" ] ; then

					if [ "`cat /opt/radic_v1.6/radic.conf | head -n 37 | tail -n 1 | cut -d '=' -f 2`" = "yes" ] ; then
						send-sms
					fi

					if [ "`cat /opt/radic_v1.6/radic.conf | head -n 35 | tail -n 1 | cut -d '=' -f 2`" = "yes" ] ; then
						send-mail
					fi
				fi
			else
				if [ "`cat /opt/radic_v1.6/radic.conf | head -n 37 | tail -n 1 | cut -d '=' -f 2`" = "yes" ] ; then
					send-sms
				fi

				if [ "`cat /opt/radic_v1.6/radic.conf | head -n 35 | tail -n 1 | cut -d '=' -f 2`" = "yes" ] ; then
					send-mail
				fi
			fi
		else
			if [ "`cat /opt/radic_v1.6/radic.conf | head -n 37 | tail -n 1 | cut -d '=' -f 2`" = "yes" ] ; then
				send-sms
			fi

			if [ "`cat /opt/radic_v1.6/radic.conf | head -n 35 | tail -n 1 | cut -d '=' -f 2`" = "yes" ] ; then
				send-mail
			fi
		fi
	done

fi
