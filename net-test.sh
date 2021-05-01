echo "for server at : JAPAN"
echo "--------------------------------"
echo "ping result"
ping -c 10 34.85.14.99 | tail -n3
sleep 1
echo "curl result"
curl -o /dev/null -s -w 'Total: %{time_total}s\n' http://34.85.14.99
sleep 1
echo "tracepath result"
#tracepath -n 34.85.14.99
echo -e "\n\n"
echo "for server at : MUMBAI"
echo "--------------------------------"
echo "ping result"
ping -c 10 34.93.56.167 | tail -n3
sleep 1
echo "curl result"
curl -o /dev/null -s -w 'Total: %{time_total}s\n' http://34.93.56.167
sleep 1
echo "tracepath result"
#tracepath -n 34.93.56.167
echo "\n\n"

echo "for server at : HONGKONG"
echo "--------------------------------"
echo "ping result"
ping -c 10 35.241.67.111  | tail -n3
sleep 1
echo "curl result"
curl -o /dev/null -s -w 'Total: %{time_total}s\n' http://35.241.67.111 
sleep 1
echo "tracepath result"
tracepath -n 35.241.67.111 

echo "finished"

echo "HONGKONG:" ping -c 4 35.241.67.111 | tail -1| awk '{print $4}' | cut -d '/' -f 2;
echo "JAPAN:" ping -c 4 34.85.14.99 | tail -1| awk '{print $4}' | cut -d '/' -f 2;
echo "MUMBAI:" ping -c 4 34.93.56.167 | tail -1| awk '{print $4}' | cut -d '/' -f 2;

