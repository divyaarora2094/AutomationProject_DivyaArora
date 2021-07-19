#! /bin/sh

sudo touch /etc/cron.d
sudo echo "30 0 * * * root /home/ubuntu/automation.sh" > /etc/cron.d
sudo chmod 600 /etc/cron.d

sudo apt update -y

if [[ !$(dpkg --get-selections | grep apache) ]]; then
      sudo apt-get install apache2
fi
ps cax | grep httpd
if [ $? -eq 1 ]
 then
 echo "Process is running."
else  [ $? -eq 0 ]
 echo "Process is not running"
fi

sudo systemctl is-enabled apache2

sudo tar -zcvf Divya-httpd-logs-$(date '+%d%m%Y-%H%M').tar.gz /var/log/apache2/
mv *.tar.gz /tmp

sudo apt update
sudo apt install awscli

aws s3 \
cp /tmp/Divya-httpd-logs-$(date '+%d%m%Y-%H%M').tar.gz \
s3://^arn:aws:s3:::upgrad-divya/$Divya-httpd-logs-$(date '+%d%m%Y-%H%M').tar.gz

if [[ ! -e /var/www/html/inventory.html ]];
 then
    mkdir -p /var/www/html/
    touch /var/www/htm/inventory.html
fi


