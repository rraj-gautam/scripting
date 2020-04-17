#!/bin/bash
parentJob=first-job                      #job you are copying from
newJob=second-job                        #job you are copying to

ParentJob=$(echo "$parentJob" | sed 's/ /%20/g')    #handle spaces in filename
NewJob=$(echo "$newJob" | sed 's/ /%20/g')

ChangeFrom=$changeFrom                              #if you need to make any changes in configurations
ChangeTo=$changeTo 

User=user
Api=user-api
#URL=$JENKINS_URL
URL=https://jenkins.example.com/
MYVIEW=$view                            #view where you want your job to be created at.


curl -X GET "${URL}job/${ParentJob}/config.xml" -u $User:$Api -o "${ParentJob}.xml"

sed -i "s/$ChangeFrom/$ChangeTo/g" "${ParentJob}.xml"

curl -s -XPOST "${URL}view/${MYVIEW}/createItem?name=${NewJob}" -u $User:$Api --data-binary @${ParentJob}.xml -H "Content-Type:text/xml"
