#!/bin/bash

curpath=`dirname $0`
echo "curpath $curpath"
cd $curpath

if [ $# -ne 1 ];then
	echo "Usage:$0 host"
	exit 1
fi

host=$1
config_yaml=session.yaml

#generate login.exp
expfile="login_$host.exp"

function create_expfile()
{
	echo "#!/usr/bin/expect" > $expfile
}

function append_expfile()
{
	echo $1 >> $expfile
}

#create login.exp
create_expfile

#get automate lenth
len=`cat $config_yaml | shyaml get-length $host.automate`

[[ $len -gt 0 ]] && last_index=`expr $len - 1` || last_index=0
echo "len:$len,last_index:$last_index"

#generate first jump
sshlogin=`cat $config_yaml|shyaml get-value $host.sshlogin`
append_expfile "spawn $sshlogin"

#loop automate
for ((i = 0; i < $len; i++))
do
	echo "i:$i"
	expect=`cat $config_yaml | shyaml get-value $host.automate.$i.expect`
	send=`cat $config_yaml| shyaml get-value $host.automate.$i.send`

	#support google MFA
    if [ "$expect" == "OTP" ];then
        send=`python3 ~/go/src/github.com/grahammitchell/google-authenticator/google-authenticator.py|awk '{print $2}'`
    fi

	#append to expfile
	if [ $i -eq $last_index ];then
		append_expfile "expect \"$expect\" {send \"$send\\n\";interact}" 
	else
		append_expfile "expect \"$expect\" {send \"$send\\n\"}" 
	fi
	
done

chmod +x $expfile
./$expfile
