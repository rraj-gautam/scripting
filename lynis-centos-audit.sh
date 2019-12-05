#!/bin/bash

yum install epel-release -y
yum install lynis -y


hostnamectl set-hostname $1


systemctl stop postfix
systemctl disable postfix
yum remove postfix -y
userdel postfix

yum install yum-utils -y

useradd sysadmin
echo "F1s0ft@123" | passwd --stdin sysadmin 


echo "####################################################################" > /etc/issue.net
echo "#        Welcome to System                                         #" >> /etc/issue.net
echo "#     All connections are monitored and recorded                   #" >> /etc/issue.net
echo "#    Disconnect IMMEDIATELY if you are not an authorized user!     #" >> /etc/issue.net
echo "#################################################################### >> /etc/issue.net

#password-aging
sed -i 's/PASS_/#PASS_/g' /etc/login.defs
cat <<EOF>>/etc/login.defs 
PASS_MAX_DAYS   90 
PASS_MIN_DAYS  60 
PASS_MIN_LEN   8 
PASS_WARN_AGE  7 
EOF


# at /etc/ssh/sshd_config file, modify some below lines:
#                                                       PermitRootLogin no
#                                                       MaxAuthTries 3
#                                                       MaxSessions 2
#                                                       Port 2194
#                                                       AllowAgentForwarding no
#                                                       AllowTcpForwarding no
#                                                       X11Forwarding no
#                                                       Banner /etc/issue.net
#restart sshd:  systemctl restart sshd


touch /etc/modprobe.d/block_usb.conf      
echo "install usb-storage /bin/true" > /etc/modprobe.d/block_usb.conf
#this is fake install. This causes the ‘/bin/true’ to run instead of installing usb-storage module

lynis audit system
grep Warning /var/log/lynis.log
grep Suggestion /var/log/lynis.log
