#!/bin/bash
User=
Api=
URL=$JENKINS_URL
ChangeFrom=$(echo "$parentView"|cut -d'-' -f1)
ChangeTo=$(echo "$newView"|cut -d'-' -f1)
TokenFrom=$(echo $ChangeFrom|tr [a-z] [A-Z])
TokenTo=$(echo $ChangeTo|tr [a-z] [A-Z])

curl -s -X GET ${URL}view/${parentView}/api/json?pretty=true -u $User:$Api|jq -r '.jobs[].name' > jobs.txt
curl -X POST -u $User:$Api --form name=$newView --form mode=hudson.model.ListView --form json='{"name": "'$newView'", "mode": "hudson.model.ListView"}' ${URL}createView

cat jobs.txt|while read Job; do
ParentJob=$(echo "$Job" | sed 's/ /%20/g')
NewJob=$(echo "$Job" | sed "s/$ChangeFrom/$ChangeTo/g"|sed 's/ /%20/g')

if [ "$ParentJob" == "$NewJob" ]
then
        NewJob=${NewJob}-${ChangeTo}
fi



curl -X GET "${URL}job/${ParentJob}/config.xml" -u $User:$Api -o "${ParentJob}.xml"

sed -i "s/$ChangeFrom/$ChangeTo/g" "${ParentJob}.xml"
sed -i "s/$TokenFrom/$TokenTo/g" "${ParentJob}.xml"
sed -i -e "s/\(<recipients>\).*\(<\/recipients>\)/<recipients>$email<\/recipients>)/g" "${ParentJob}.xml"

curl -s -XPOST "${URL}view/${newView}/createItem?name=${NewJob}" -u $User:$Api --data-binary @${ParentJob}.xml -H "Content-Type:text/xml"
done
