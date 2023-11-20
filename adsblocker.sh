#!/bin/bash

echo "...Start..."
apt-get update
apt-get upgrade -y

echo "...Installing Bind9..."
apt-get install -y bind9

echo "...Copying Configuration Files..."
cp named.conf /etc/bind/named.conf
cp adsblocker.py /etc/bind/adsblocker.py

echo "...Fetch updated domain list..."
python3 adsblocker.py

echo "...Restart Services..."
systemctl restart named

systemctl restart bind9

echo "...Verify Data..."
named-checkconf
named-checkzone rpz /etc/bind/adsblocker.db



echo "...Set Cronjob for future update..."
crontab -l > adblocker
echo "0 0 * * 0 sudo python3 /etc/bind/adsblocker.py >> /etc/bind/adsblocker.log" >> adblocker
crontab adblocker

rm adblocker
echo "...Finish..."



