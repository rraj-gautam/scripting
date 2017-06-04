#!/bin/sh
#list networks
#**************run with a [. ./filename.sh]********** 
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
	echo "skipped to next step- "
#	echo "y/n?"
#	read decision1
fi

echo ".......also list all saved coonections:........? y/n?"
read decision2
if [ "$decision2" == "y" ]
then
	nmcli c
else 
	echo "thank you, see you again"
fi
