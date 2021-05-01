#!/bin/bash

#run script with ->  ./scriptname databasename

SET FOREIGN_KEY_CHECKS = 0;

DATABASE_NAME=$1

# get the db user from the keyboard
read -p "DB User: " DBUSER

#get the db password from the keyboard
read -s -p "DB Password: " DBPASSWORD

# just to move to the next line
echo ""

#take backup first
mysqldump -u$DBUSER -p$DBPASSWORD $1 > $1.sql

 # truncate all the tables in one go
mysql -Nse 'show tables' -D $DATABASE_NAME -u$DBUSER -p$DBPASSWORD | while read table; do echo "SET FOREIGN_KEY_CHECKS = 0;truncate table \$table\;SET FOREIGN_KEY_CHECKS = 1;"; done | mysql $DATABASE_NAME -u$DBUSER -p$DBPASSWORD

exit 0

SET FOREIGN_KEY_CHECKS=1;
