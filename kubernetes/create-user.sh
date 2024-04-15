#/bin/sh

if [ $# != 3 ]; then
    >&2 echo "./createuser.sh <username> <group> <validity_days>"
    exit 1
fi


user=$1
group=$2
days=$3

if [ "$UID" == "0" ]; then
  #generate csr for user
	openssl genrsa -out $user.key 2048

	#here, specify the user and group
	openssl req -new -key $user.key -out $user.csr -subj "/CN=$user/O=$group"
	#If the user has multiple groups
	#openssl req -new -key jean.key  -out jean.csr -subj "/CN=jean/O=$group1/O=$group2/O=$group3"

	#approve csr
	openssl x509 -req -in $user.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out $user.crt -days $days
	mkdir users/$user
	mv $user.csr $user.crt $user.key users/$user/
	cp config.yaml users/$user/$user.yaml

	#create user inside k8s cluster
	kubectl config set-credentials $user --client-certificate=users/$user/$user.crt  --client-key=users/$user/$user.key

	crt=$(cat users/$user/$user.crt | base64 | tr -d '\n')
	key=$(cat users/$user/$user.key | base64 | tr -d '\n')
	sed -i "s|templateuser|$user|g" users/$user/$user.yaml
	sed -i "s|usercrt|$crt|g" users/$user/$user.yaml
	sed -i "s|userkey|$key|g" users/$user/$user.yaml

	#create context for the user
	#kubectl config set-context $user-context --cluster=kubernetes --user=$user
else
	echo "run as sudo"
        exit
fi
