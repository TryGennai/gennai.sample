#!/bin/sh

GUNGNIR_SERVER_FILE=gungnir-server-0.0.1-20140725.tar.gz
GUNGNIR_CLIENT_FILE=gungnir-client-0.0.1-20140725.tar.gz
GUNGNIR_VERSION=0.0.1
GUNGNIR_INSTALL_DIR=/opt
GUNGNIR_USER=vagrant
GUNGNIR_GROUP=vagrant

echo "in gungnir."

if [ -d "${GUNGNIR_INSTALL_DIR}/gungnir-server" ] ; then
	echo " - already."
	exit
fi

cd /tmp

echo " - download."
curl -L -O https://s3-ap-northeast-1.amazonaws.com/gennai/${GUNGNIR_SERVER_FILE} >/dev/null 2>&1
curl -L -O https://s3-ap-northeast-1.amazonaws.com/gennai/${GUNGNIR_CLIENT_FILE} >/dev/null 2>&1

echo " - install."

tar zxf ${GUNGNIR_SERVER_FILE} -C ${GUNGNIR_INSTALL_DIR}
tar zxf ${GUNGNIR_CLIENT_FILE} -C ${GUNGNIR_INSTALL_DIR}

chown -R ${GUNGNIR_USER}:${GUNGNIR_GROUP} ${GUNGNIR_INSTALL_DIR}/gungnir-server-${GUNGNIR_VERSION}
chown -R ${GUNGNIR_USER}:${GUNGNIR_GROUP} ${GUNGNIR_INSTALL_DIR}/gungnir-client-${GUNGNIR_VERSION}

ln -s ${GUNGNIR_INSTALL_DIR}/gungnir-server-${GUNGNIR_VERSION} ${GUNGNIR_INSTALL_DIR}/gungnir-server
ln -s ${GUNGNIR_INSTALL_DIR}/gungnir-client-${GUNGNIR_VERSION} ${GUNGNIR_INSTALL_DIR}/gungnir-client

echo " - setting."
cp /vagrant/files/gungnir.yaml ${GUNGNIR_INSTALL_DIR}/gungnir-server/conf

mkdir -p /var/log/gungnir
chown -R ${GUNGNIR_USER}:${GUNGNIR_GROUP} /var/log/gungnir

echo "" >> /home/${GUNGNIR_USER}/.bashrc
echo "export GUNGNIR_SERVER_HOME=${GUNGNIR_INSTALL_DIR}/gungnir-server" >> /home/${GUNGNIR_USER}/.bashrc
echo "export GUNGNIR_CLIENT_HOME=${GUNGNIR_INSTALL_DIR}/gungnir-client" >> /home/${GUNGNIR_USER}/.bashrc
echo "export PATH=\${GUNGNIR_CLIENT_HOME}/bin:\${PATH}" >> /home/${GUNGNIR_USER}/.bashrc

echo " - service."
cp /vagrant/files/gungnir-server.initd /etc/rc.d/init.d/gungnir-server
chkconfig --add gungnir-server
service gungnir-server start

# TODO:

echo " - clean."
rm -rf /tmp/gungnir*

exit
