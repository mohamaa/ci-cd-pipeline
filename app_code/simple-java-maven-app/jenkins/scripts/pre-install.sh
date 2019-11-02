#!/usr/bin/env bash

echo 'The following commands install Maven to run Maven-built Java application'
yum install -y java-1.8.0-openjdk-devel
java -version
cd /usr/local/src
wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
tar -xf apache-maven-3.5.4-bin.tar.gz
mv apache-maven-3.5.4/ apache-maven/ 
cd /etc/profile.d/
vim maven.sh
export M2_HOME=/usr/local/src/apache-maven
export PATH=${M2_HOME}/bin:${PATH}
chmod +x maven.sh
source /etc/profile.d/maven.sh
mvn --version