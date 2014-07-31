#!/bin/sh

echo "in mongod."

if [ -f /etc/yum.repos.d/mongodb.repo ] ; then
	echo " - already."
	exit
fi

echo " - add repository."
cp /vagrant/files/mongodb.repo /etc/yum.repos.d/

echo " - install."
yum install -y mongodb-org > /dev/null 2>&1

echo " - service."
service mongod start
