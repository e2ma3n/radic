# Radic - Alerting to sysadmins with text message and email in emergency conditions 
## Introduction
This program written by E2MA3N for monitoring memory, cpu and disk usages on linux systems. this is a simple program for alerting to sysadmins with text message and email in emergency conditions.

The project page is located at https://github.com/e2ma3n/radic

## What distributions are supported ?
Tested on all popular linux distributions such as debian 8, CentOS 6 and Ubuntu 14.04

* Linux Debian 8.x
* Linux CentOS 6.x
* Linux Ubuntu 14.04 LTS

## Dependencies

| Dependency | Description |
| ---------- | ----------- |
| whoami     | Print the user name associated with the current effective user ID.  Same as id -un. |
| grep       | grep searches the named input FILEs (or standard input if no files are named, or if a single hyphen-minus (-) is given as file name) for lines containing a match to the given PATTERN.  By default, grep prints the matching lines. |
| free       | free displays the total amount of free and used physical and swap memory in the system, as well as the buffers used by the kernel. |
| cut        | Print selected parts of lines from each FILE to standard output. |
| cat        | Concatenate FILE(s), or standard input, to standard output. |
| head       | Print  the first 10 lines of each FILE to standard output. |
| tail       | Print  the  last 10 lines of each FILE to standard output. |
| date       | Display the current time in the given FORMAT, or set the system date. |
| cp         | Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY. |
| sleep      | Pause for NUMBER seconds. |
| curl       | curl is a tool to transfer data from or to a server. |
| expr       | evaluate expressions |
| iostat     | The iostat command is used for monitoring system input/output device loading by observing the time the devices are active in relation to their average transfer rates. |

## How to get source code ?
You can download and view source code from github : https://github.com/e2ma3n/radic

Also to get the latest source code, run following command:
```
# git clone https://github.com/e2ma3n/radic.git
```
This will create loep directory in your current directory and source files are stored there.

## How to check dependencies on system ?
In the first step, set execute permission for install.sh :
```
# cd radic
# chmod +x install.sh
```
Then, check dependencies, using -c switch :
```
# ./install -c
```

## How to install dependencies on debian ?
By using apt-get command; for example :
```
# apt-get install sysstat
# apt-get install heirloom-mailx
# apt-get install curl
...
```

## How to install radic ?
By using -i switch :
```
# ./install.sh -i
```

## How to test mail and sms function ?
```
# radic --test_mail # plaese see varbose
# radic --test_sms # please see verbose
```

## How to uninstall ?
First remove radic directory
```
# rm -rf /opt/radic_v1.6/
```
Then. delete /opt/radic_v1.6/radic.sh from /etc/crontab


## Fixing centos bug :
```
# Error : Missing "nss-config-dir" variable.
# Patch : add '-S nss-config-dir=/etc/pki/nssdb/' to mailx's options
```

## Notes :
	1. You should edit config file
	2. this program now is compatible with sms[dot]ir panel

## License
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
