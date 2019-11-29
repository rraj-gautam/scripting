#!/bin/bash

/usr/bin/mysqldump -u user -pPassword db | gzip >/backup/dbname-`date +%Y-%m-%d_%H-%M-%S`.sql.gz

find /backup -type f -mtime +7 –delete

#crontab -e
#0 0 * * * /bin/bash /backup/script/backup.sh
