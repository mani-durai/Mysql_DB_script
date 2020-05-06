# Mysql_DB_script
Take all database backup script


The My-SQL Backup script will take all the My-SQL databases separately in .Sql format excluding default databases (Information schema, Performance Schema and Mysql)
and it will use the  gzip command to zip all the databases next we are using the tar command to tar all the databases into single backup file and we are uploading to S3. If the backup file is successfully created or not we will get a notification via email.
We are going to upload the backup file to S3 using the AWS-CLI. Once the upload to S3 is success or failure we will get an notification via email.
We are going to delete the backups older than 7 days locally using the find command.

You need to have the following information for the script to work perfectly.

My-SQL UserName: root

My-SQL PassWord: xxxx

S3 Bucket: xxx

From Mail ID:

To Mail ID: 

Mail command need to be Installed in the Linux Machine
