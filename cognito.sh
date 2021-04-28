#!/bin/bash

set -xe

############################  README  ####################################################
######### we need to make sure of following things:                             ##########
######### 1. User_Pool_ID                                                       ##########
######### 2. IAM_ROLE_ARN ( iam role for cognito to send logs to cloudwatch )   ##########
######### 3. CSV file with correct headers(coulmns)                             ##########
######### 4. You can give any Name for Import_Job_Name                          ##########
######### 5. We need to wait for importJob to get finished.                     ##########
#########    So, set sleep time is set as a wait time                           ##########
######### 6. Newly imported Users and their Sub ID is stored in                 ##########
#########    file "NewImportedUsers.json"                                       ##########
######### 7. Library dependencies to be installed in host machine:              ##########
#########    - jq                                                               ##########
#########    - aws cli                                                          ##########
##########################################################################################

Import_Job_Name=MyImportJobBash
User_Pool_ID=eu-central-1_000000
IAM_ROLE_ARN=arn:aws:iam::000123456:role/service-role/Cognito-UserImport-Role
filelocation=/home/rishi/Downloads/import-cognito-users.csv
Region=eu-central-1

##### create User Import Job and get presigned URL and JobID #####
function createImportJob()
{
    local job=$(aws cognito-idp create-user-import-job --user-pool-id ${User_Pool_ID} --job-name ${Import_Job_Name} --cloud-watch-logs-role-arn ${IAM_ROLE_ARN} --region ${Region})
    PreSignedUrl=$(echo $job | jq .UserImportJob.PreSignedUrl|tr -d "\"") 
    JobID=$(echo $job | jq .UserImportJob.JobId|tr -d "\"")
}

##### list User import JOb #####
function listImportJob()
{
    local job=$(aws cognito-idp list-user-import-jobs --user-pool-id ${User_Pool_ID} --region ${Region} --max-results 1)
    status=$(echo $job|jq .UserImportJobs[].Status|tr -d "\"")
}

##### Upload CSV file to import Job URL using PUT request method #####
function uploadCSV()
{
    curl -v -T "${filelocation}" -H "x-amz-server-side-encryption:aws:kms" "$1"
}

##### Start the import user job #####
function startImport()
{
    aws cognito-idp start-user-import-job --user-pool-id ${User_Pool_ID} --region ${Region} --job-id $1 &>/dev/null
    echo "Job Started"
}

##### list all available users in cognito #####
function listUsers()
{
    aws cognito-idp list-users --user-pool-id ${User_Pool_ID} --region ${Region} --attributes-to-get "email" "sub" | jq .Users[] > $1

}

##### extract user's email and sub ID from cognito users list #####
# function getUserDetails()
# {
#     listUsers
#     echo $users | jq  '.Users[].Attributes[]'|sed  -e '/-/{n;N;d;}' > $1
# }

##### gets new userdetails, compares with existing one and writes to a new file #####
function importedUserDetails()
{
    listUsers UsersAfterImport.json;
    diff  UsersBeforeImport.json UsersAfterImport.json | grep '>' |cut -c 3- | grep 'Username' -A 8  > NewImportedUsers.json  || true
    rm -f UsersBeforeImport.json UsersAfterImport.json
}

##### check the status of import job #####
function checkImportStatus()
{
    listImportJob
    if [[ "$status" == "Failed" || "$status" == "Succeeded" ]]
    then 
        importedUserDetails;
        echo "Import Succeeed"
    else
        echo "Waiting 10s more..."
        sleep 10;
        checkImportStatus;
    fi              
}

listUsers UsersBeforeImport.json; #get all existing users in cognito and write to file UsersBeforImport.json. This file is later removed.
createImportJob;
uploadCSV $PreSignedUrl;
startImport $JobID;

checkImportStatus;
