#!/bin/sh

echo "in storm."

STORM_VERSION=0.9.0.1
STORM_TAR_FILE=storm-${STORM_VERSION}.tar.gz
STORM_INSTALL_DIR=/opt
STORM_USER=vagrant
STORM_GROUP=vagrant

if [ -d ${STORM_INSTALL_DIR}/storm-${STORM_VERSION} ] ; then
	echo " - already."
	exit
fi

echo " - packages install."
yum install -y gcc gcc-c++ git autoconf libtool libuuid-devel >/dev/null 2>&1


echo " - zeromq."

if [ ! -d /usr/local/src/zeromq-2.1.7 ] ; then
	cd /tmp
	curl -L -O https://s3-ap-northeast-1.amazonaws.com/gennai/binary/zeromq-2.1.7.tar.gz >/dev/null 2>&1
	tar zxf zeromq-2.1.7.tar.gz -C /usr/local/src
	cd /usr/local/src/zeromq-2.1.7
	./autogen.sh >/dev/null 2>&1
	./configure >/dev/null 2>&1
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
else
	echo " -- already."
fi

echo " - jzmq."

if [ ! -d /usr/local/src/jzmq ] ; then
	cd /tmp
	curl -L -O https://s3-ap-northeast-1.amazonaws.com/gennai/binary/jzmq2.tar.gz >/dev/null 2>&1
	tar zxf jzmq2.tar.gz -C /usr/local/src
	cd /usr/local/src/jzmq
	./autogen.sh >/dev/null 2>&1
	./configure >/dev/null 2>&1
	make >/dev/null 2>&1
	make install >/dev/null 2>&1
else
	echo " -- already."
fi

cd /tmp

echo " - download."
curl -L -O https://s3-ap-northeast-1.amazonaws.com/gennai/binary/${STORM_TAR_FILE} >/dev/null 2>&1

echo " - instal."
tar zxf ${STORM_TAR_FILE} -C ${STORM_INSTALL_DIR}
chown -R ${STORM_USER}:${STORM_GROUP} ${STORM_INSTALL_DIR}/storm-${STORM_VERSION}
ln -s ${STORM_INSTALL_DIR}/storm-${STORM_VERSION} ${STORM_INSTALL_DIR}/storm

echo " - setting."
cp /vagrant/files/storm.yaml ${STORM_INSTALL_DIR}/storm/conf/

echo "" >> /home/${STORM_USER}/.bashrc
echo "export STORM_HOME=${STORM_INSTALL_DIR}/storm" >> /home/${STORM_USER}/.bashrc
echo "export PATH=\${STORM_HOME}/bin:\${PATH}" >> /home/${STORM_USER}/.bashrc

mkdir -p /var/log/storm
chown -R ${STORM_USER}:${STORM_GROUP} /var/log/storm

mkdir -p /var/run/storm
chown -R ${STORM_USER}:${STORM_GROUP} /var/run/storm

echo " - service."
cp /vagrant/files/storm-nimbus.initd /etc/rc.d/init.d/storm-nimbus
chkconfig --add storm-nimbus
service storm-nimbus start

cp /vagrant/files/storm-supervisor.initd /etc/rc.d/init.d/storm-supervisor
chkconfig --add storm-supervisor
service storm-supervisor start

cp /vagrant/files/storm-ui.initd /etc/rc.d/init.d/storm-ui
chkconfig --add storm-ui
# service storm-ui start

echo " - clean."
rm -rf /tmp/zeromq-2.1.7.tar.gz
rm -rf /tmp/jzmq2.tar.gz
rm -rf /tmp/${STORM_TAR_FILE}

exit
