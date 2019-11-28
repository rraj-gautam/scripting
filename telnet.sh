#!/bin/bash

#function value(){
#	return $1;
#}

function checkup(){
	echo up>stat
	y=$(cat stat|md5sum)
	x=$(cat statfinal|md5sum)
#	z=1
#	y=z
#	x=value;
	if [[ "$y" != "$x" ]]
	then
		smsup1;
	else
		echo "already up"
	fi
	echo up>statfinal
#	value x
}

function checkdown(){
	echo down>stat
	y=$(cat stat|md5sum)
	x=$(cat statfinal|md5sum)
#	z=0
#	y=z
#	x=value;
	if [[ "$y" != "$x" ]]
	then
		smsdown1;
	else
	fi
	echo down>statfinal
#	value y;
}

function smsup1(){
	echo "server is up"
}
function smsdown1(){
	echo "server is down"
}

#value 1;
host=$1
port=$2
r=$(bash -c 'exec 3<> /dev/tcp/'$host'/'$port';echo $?' 2>/dev/null)
if [ "$r" = "0" ]; then
	checkup;
else
	checkdown;
	exit 1 # To force fail result in ShellScript
fi
