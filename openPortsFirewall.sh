netstat -anlpt|grep LIST|awk '{print $4}' | awk -F: '{print $NF}' > ports.txt
while read i;
do
firewall-cmd --add-port=$i/tcp --permanent
done < ports.txt
firewall-cmd --reload
