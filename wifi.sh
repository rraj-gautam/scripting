#!/bin/sh
#list networks
#run with a [. ./filename.sh] 
#inorder to make the variables included within same bash
#ie.In order to receive environment changes back from the script
#  
echo "do you want to list all available connections? y/n"
read decision1
#export decision1
if [ $decision1 == "y" ]
#space between operators is needed so that shell doesnot treat the 
#condition/operation as vairable.
then
	nmcli d wifi list
#elif [ "$decision" == "n" ] ###"$decision" and $decision are same
#then
#	echo "thank you"
else
	break
#	echo "skipped to next step- "
#	echo "y/n?"
#	read decision1
fi

#echo ".......also list all saved coonections:........? y/n?"
#read decision2
#if [ "$decision2" == "y" ]
#then
#	nmcli c
#	ping -c 3 8.8.8.8
#else 
#	echo "thank you, see you again"
#fi

echo "enter the ssid you want to connect: "
read ssidname
echo "enter the password: "
read ssidpassword

nmcli d wifi connect $ssidname password $ssidpassword

echo "checking network connection...................................................."
espeak "checking network connection"
if (ping -c 3 8.8.8.8) then
	echo "connected successfully" $ssidname
	espeak "connected successfully" $ssidname

else
	echo "connection failed. please try with correct information"
	espeak "connection failed. please try with correct information"


	echo "trying for saved connection......"
	nmcli d connect wlp9s0     #written only to connect to saved network. change the wlp9s0 with your interface name
fi


