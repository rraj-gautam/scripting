#!/bin/bash
apt-get update

echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    iptables-persistent
    
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
  
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "net.ipv4.ip_forward = 1" | tee -a /etc/sysctl.conf
echo "net.ipv6.conf.all.forwarding = 1" | tee -a /etc/sysctl.conf
sysctl -p

docker volume create --name ymy_openvpn  #for saving configs
#create config files
docker run -v ymy_openvpn:/etc/openvpn --log-driver=none --rm kylemanna/openvpn ovpn_genconfig -u udp://${vpn_endpoint} -d -p "route ${route_1}" -p "route ${route_2}"
#create certificates
docker run -v ymy_openvpn:/etc/openvpn --log-driver=none --rm -e "EASYRSA_BATCH=1" -e "EASYRSA_REQ_CN=Ymy CA" kylemanna/openvpn ovpn_initpki nopass
#Start OpenVPN server process
docker run -v ymy_openvpn:/etc/openvpn -d --net=host --name openvpn --restart always --cap-add=NET_ADMIN kylemanna/openvpn

#
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -j SNAT --to-source ${openVpnServer_private_ip}
iptables-save > /etc/iptables/rules.v4

#reference for container: https://hub.docker.com/r/kylemanna/openvpn
