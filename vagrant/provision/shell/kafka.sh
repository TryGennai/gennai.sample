#!/bin/sh

echo "in kafka."

SCALA_VERSION=2.8.0
KAFKA_VERSION=0.8.0
KAFKA_TAR_FILE=kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tar.gz
KAFKA_INSTALL_DIR=/opt
KAFKA_USER=vagrant
KAFKA_GROUP=vagrant

if [ -d "${KAFKA_INSTALL_DIR}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}" ] ; then
	echo " - already."
	exit
fi

cd /tmp

echo " - download."
curl -L -O https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/${KAFKA_TAR_FILE} >/dev/null 2>&1

echo " - install."
tar zxf ${KAFKA_TAR_FILE} -C ${KAFKA_INSTALL_DIR}
chown -R ${KAFKA_USER}:${KAFKA_GROUP} ${KAFKA_INSTALL_DIR}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ln -s ${KAFKA_INSTALL_DIR}/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_INSTALL_DIR}/kafka

echo " - setting."
cp /vagrant/files/kafka.server.properties ${KAFKA_INSTALL_DIR}/kafka/config/server.properties
mkdir -p /data/kafka
chown -R ${KAFKA_USER}:${KAFKA_GROUP} /data/kafka

mkdir -p /var/log/kafka
chown -R ${KAFKA_USER}:${KAFKA_GROUP} /var/log/kafka

cp /vagrant/files/kafkaServer ${KAFKA_INSTALL_DIR}/kafka/bin/

echo "" >> /home/${KAFKA_USER}/.bashrc
echo "export KAFKA_HOME=${KAFKA_INSTALL_DIR}/kafka" >> /home/${KAFKA_USER}/.bashrc
echo "export PATH=\${KAFKA_HOME}/bin:\${PATH}" >> /home/${KAFKA_USER}/.bashrc

echo " - service."
cp /vagrant/files/kafka.initd /etc/init.d/kafka
chkconfig --add kafka
service kafka start

echo " - clean."
rm -rf /tmp/${KAFKA_TAR_FILE}
