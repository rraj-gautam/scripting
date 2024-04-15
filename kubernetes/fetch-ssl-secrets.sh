#!/bin/sh

if ! [ -x "$(command -v jq)" ]; then
    echo "jq could not be found"
    echo "You need to install jq: yum install jq / dnf install jq / apt install jq"
    exit 1
fi
if ! [ -x "$(command -v base64)" ]; then
    echo "jq could not be found"
    echo "You need to install base64 encoder/decoder"
    exit 1
fi
if ! [ -x "$(command -v curl)" ]; then
    echo "jq could not be found"
    echo "You need to install curl. yum install curl / dnf install curl / apt install curl"
    exit 1
fi

SSL_SECRET_NAME="example-tls-secret"

# This is a Bearer Token that you need to generate for service account. 
# $kubectl create token default -n default --bound-object-kind Secret --bound-object-name example-tls-secret --duration 8760h #1 year validation. By default it is 24h.
# Encode it in base64 and paste here. So that later we will decode it in script.
TOKEN=$(echo -n "<BASE64_ENCODED_BEARER_TOKEN>"|base64 -d)

# This is the base64 encoded content of /etc/kubernetes/ca.crt  
echo "<BASE64_CA_CRT>" | base64 -d >/tmp/ca.crt

# This fetches secret from k8s server, decodes it and stores in /tmp folder.
curl -k -s -X GET https://<API_SERVER_IP/DOMAIN>:<API_SERVER_PORT>/api/v1/namespaces/certificates/secrets/${SSL_SECRET_NAME} --header "Authorization: Bearer $TOKEN" --cacert /tmp/ca.crt | jq '.data."tls.crt"' | tr -d '"' |base64 -d > /tmp/tls.crt
curl -k -s -X GET https://<API_SERVER_IP/DOMAIN>:<API_SERVER_PORT>/api/v1/namespaces/certificates/secrets/${SSL_SECRET_NAME} --header "Authorization: Bearer $TOKEN" --cacert /tmp/ca.crt | jq '.data."tls.key"' | tr -d '"' |base64 -d > /tmp/tls.key

if [ $? -eq 0 ]; then
	echo "---------------------------------------------------"
	echo "SSL has been generated. Please check in /tmp folder"
	echo "---------------------------------------------------"
	echo "---------- certificate > /tmp/tls.crt -------------"
	echo "---------- private key > /tmp/tls.crt -------------"
	echo "---------------------------------------------------"
else 
	echo "!!! SSL generation failed !!!"
fi
