#!/bin/sh

USER=vagrant

echo "in jdk."

if [ ! -d /usr/java/jdk1.6.0_45 ] ;  then

	cd /tmp
	echo " - download."
	curl -L -O https://s3-ap-northeast-1.amazonaws.com/gennai/binary/jdk-6u45-linux-x64-rpm.bin >/dev/null 2>&1

	echo " - install."
	chmod +x ./jdk-6u45-linux-x64-rpm.bin
	./jdk-6u45-linux-x64-rpm.bin >/dev/null 2>&1

	# environment
	echo "export JAVA_HOME=/usr/java/default" >> /home/${USER}/.bashrc
	echo "export PATH=\${JAVA_HOME}/bin:\${PATH}" >> /home/${USER}/.bashrc

	echo ${SCRIPT} >> ~/.bashrc
	
	# cleanup
	rm /tmp/jdk-6u45-linux-x64-rpm.bin
	rm /tmp/jdk-6u45-linux-amd64.rpm
	rm sun-javadb-*.rpm
else
	echo " - already."
fi
