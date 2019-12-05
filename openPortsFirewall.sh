netstat -anlpt|grep LIST|awk '{print $4}' | awk -F: '{print $NF}' > ports.txt
while read i;
do
firewall-cmd --add-port=$i/tcp --permanent
done < ports.txt
firewall-cmd --reload


##### rich-rule #####
## firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.13.222.55" port protocol="udp" port="161" accept'
## firewall-cmd --permanent --zone=public --add-rich-rule='rule family="ipv4" source address="10.13.212.2" port protocol="tcp" port="22" accept'
