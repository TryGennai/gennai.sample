#!/bin/sh

echo "in zookeeper."

ZK_VERSION=3.4.5
ZK_TAR_FILE=zookeeper-${ZK_VERSION}.tar.gz
ZK_INSTALL_DIR=/opt
ZK_USER=vagrant
ZK_GROUP=vagrant

if [ -d "${ZK_INSTALL_DIR}/zookeeper-${ZK_VERSION}" ] ; then
	echo " - already."
	exit
fi

cd /tmp
echo " - download."
curl -L -O http://archive.apache.org/dist/zookeeper/zookeeper-${ZK_VERSION}/${ZK_TAR_FILE} >/dev/null 2>&1

echo " - install."
tar zxf ${ZK_TAR_FILE} -C ${ZK_INSTALL_DIR}
chown -R ${ZK_USER}:${ZK_GROUP} ${ZK_INSTALL_DIR}/zookeeper-${ZK_VERSION}
ln -s ${ZK_INSTALL_DIR}/zookeeper-${ZK_VERSION} ${ZK_INSTALL_DIR}/zookeeper

echo " - setting."
cp /vagrant/files/zoo.cfg ${ZK_INSTALL_DIR}/zookeeper/conf
chown ${ZK_USER}:${ZK_GROUP} ${ZK_INSTALL_DIR}/zookeeper/conf/zoo.cfg
mkdir -p /data/zookeeper
chown -R ${ZK_USER}:${ZK_GROUP} /data/zookeeper

echo "" >> /home/${ZK_USER}/.bashrc
echo "export ZOOKEEPER_HOME=${ZK_INSTALL_DIR}/zookeeper" >> /home/${ZK_USER}/.bashrc
echo "export PATH=\${ZOOKEEPER_HOME}/bin:\${PATH}" >> /home/${ZK_USER}/.bashrc
echo "export ZOO_LOG_DIR=${ZK_INSTALL_DIR}/zookeeper" >> /home/${ZK_USER}/.bashrc

echo " - service."
cp /vagrant/files/zookeeper.initd /etc/rc.d/init.d/zookeeper
chkconfig --add zookeeper
service zookeeper start

echo " - clean."
rm -rf /tmp/${ZK_TAR_FILE}

exit
