#!/bin/bash

##this script restarts all lambda functions of your aws acccount, by adding RESTART environment variables, without deleting existing variables.

echo "You have enabled \"$AWS_PROFILE\" PROFILE. Is this the correct one where you want to run the script? [y/n]: "
read ans
case "$ans" in
[yY]|yes|YES)
true
;;
*)
false
exit
;;
esac

echo "enter your email: "
read email
tada=$(date +%F_%T)
aws lambda list-functions  --region eu-central-1 --query 'Functions[*].[FunctionName]' | grep -v -E '\[|\]'|sed 's/\"//g'|sed 's/\ //g'|while read x;
#funcNames=("test-app" "test-comments")
#for x in "${funcNames[@]}";
do

##updating environment varaibles without deleting existing variables.
echo updating environment vairiable on $x...;
CURRENTVARIABLES=$(aws lambda get-function-configuration --region eu-central-1 --function-name $x | jq '.Environment.Variables')
NEWVARIABLES=$(echo $CURRENTVARIABLES | jq '. += {"RESTART":"Restart_by_'$email'_on_'$tada'"}')
BESTVARIABLES=$(echo $NEWVARIABLES|sed 's/\:\ /\=/g'|sed -E 's/\{|\}|\"//g')
aws lambda update-function-configuration --region eu-central-1 --function-name ${x} --environment "Variables={$BESTVARIABLES}"

#if you donot need ouput on screen, then use this command instead
#aws lambda update-function-configuration --region eu-central-1 --function-name ${x} --environment "Variables={"$NEWVARIABLES"}" > /dev/null
done
