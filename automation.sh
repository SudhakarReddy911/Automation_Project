#This file is from Dev branch
name="sudhakar"
s3_bucket="upgradsudhakar"
#To update package details
sudo apt update -y
#to check package is install or not
dpkg -s apache2
#if apache2 not installed then install by using below command
if [ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ];
then
        apt install apache2 -y
fi
#if apache2 service is not running then to start it

service_running=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()')
if [ running != ${service_running} ];
then
        systemctl start apache2

fi
#if service is not enable to enable it
service_enable=$(systemctl is-enabled apache2 | grep "enabled")

if [ enabled != ${service_enable} ];
then
        systemctl enable apache2
fi
#timestamp variable hold date,month,year and time
timestamp=$(date '+%d%m%Y-%H%M%S')

cd /var/log/apache2
#tar creation of access and log files with name and timestamp
tar -cf /tmp/${name}-httpd-accesslogs-${timestamp}.tar access.log
tar -cf /tmp/${name}-httpd-errorlogs-${timestamp}.tar error.log
#if tar file present then move it to s3 bucket
if [ -f /tmp/${name}-httpd-accesslogs-${timestamp}.tar ];
then
aws s3 cp /tmp/${name}-httpd-accesslogs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-accesslogs-${timestamp}.tar
aws s3 cp /tmp/${name}-httpd-accesslogs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-errorlogs-${timestamp}.tar
fi

