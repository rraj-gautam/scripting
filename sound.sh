#/bin/bash

echo "Increase or Decrease? I/D" 
read keyboard

if [ $keyboard == 'i' ]
 then
	echo "enter the percent you want to increase by: "
	read increase
	amixer set Master $increase%+

elif  [ $keyboard == 'd' ]
 then
	echo "enter the percent to decrease by: "
	read decrease
	amixer set Master $decrease%-
else
	echo "not recognozed"
fi

#echo "press space  to see the status. "
#read -n1  status

#read -n1 -r -p "Press enter to continue..." status

pause(){
 read -n1 -rsp $'Press any key to continue or Ctrl+C to exit...\n'
}
#if [ "$status" = '' ]; then
#if [ "$status" == $"\u0020" ]
pause
	alsamixer




#fi

