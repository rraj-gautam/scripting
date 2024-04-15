# This is not a script. you need to add this to crontab of every master nodes.
# 0 0 1 */11 * /usr/bin/kubeadm certs renew all && /usr/sbin/reboot

#or
(crontab -l 2>/dev/null; echo "0 0 1 */11 * /usr/bin/kubeadm certs renew all && /usr/sbin/reboot") | crontab -
