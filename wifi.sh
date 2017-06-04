#!/bin/sh
echo "do you want to list all available connections? y/n"
read decision1
#if [$decision="y"]
#then
	nmcli d wifi list
#elif [$decision="n"] then
#else
#	echo"thank you, see you soon"
#else
#echo "y/n?"
#read decision
#fi

echo".......also list all saved coonections:........? y/n?"
read decision2
nmcli c
