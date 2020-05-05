#!/bin/bash
DATE=`date +%Y%m%d`
USER="<user>"
PASSWORD="<password>"
BUCKET="<Bucket_name>"
OUTPUT="/opt/dump/mysqldump"
FROM_MAIL="<manilid>"
TO_MAIL="<MailID>"

databases=`mysql -u $USER -p$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [ "$db" != "information_schema" ] && [ "$db" != "performance_schema" ] && [ "$db" != "mysql" ] && [ "$db" != _* ] ; then
        echo "Dumping database: $db"
        mysqldump -u $USER -p$PASSWORD --databases $db > $OUTPUT/`date +%Y%m%d`.$db.sql
       gzip $OUTPUT/`date +%Y%m%d`.$db.sql
    fi
done

cd /opt/dump/mysqldump/
tar -cvzf /opt/dump/mysqldump/all_DB_`date +%Y%m%d`.tar.gz `date +%Y%m%d`.*
if [ ! -f /opt/dump/mysqldump/all_DB_`date +%Y%m%d`.tar.gz ]; then

echo "Backup failed/File not found" | mail  -s " DB Backup failed" -r $FROM_MAIL  $TO_MAIL
exit 1

else

 aws s3 cp --profile default2 /opt/dump/mysqldump/all_DB_`date +%Y%m%d`.tar.gz  s3://$BUCKET/mysqldump/$DATE/

fi

if [ $? == 0 ]; then

echo "DB Backup file  Found and moved to s3 @ s3://BUCKET/mysqldump/$DATE/ " | mail  -s "DB  Backup file successfully moved to s3" -r $FROM_MAIL  $TO_MAIL


find /opt/dump/mysqldump/ -type f -mtime +7 -name '*.gz' -execdir rm -- {} \;

else

echo "DB Backup file  Failed to move to s3" | mail  -s "DB Backup file Failed to move to s3" -r $FROM_MAIL  $TO_MAIL

fi

