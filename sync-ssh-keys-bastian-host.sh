#!/bin/bash
### run script at bastian host. 
### store public keys at gcp storage as:
### bastian-host-keys/
###                 dev/
###                 stage/
###                 prod/

## also create use dev,stage,prod at bastian host. And make those users to connect to specific servers.

function keys(){
FILES=/root/$1/*
for i in $FILES
do
cat $i >> /root/Synced.keys
echo "" >> /root/Synced.keys
done
chmod 600 /root/Synced.keys
mv /root/Synced.keys /home/$1/.ssh/authorized_keys -f
rm -f Synced.keys
}

gsutil rsync -rcJ  gs://bastian-host-keys/ /root/
keys prod;
keys dev;
keys stage;
keys system;
