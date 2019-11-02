#!/usr/bin/env bash

echo 'The following commands install Maven to run Maven-built Java application'
sudo yum install -y java-1.8.0-openjdk-devel
java -version
cd /usr/local/src
sudo wget http://www-us.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz
sudo tar -xf apache-maven-3.5.4-bin.tar.gz
sudo mv apache-maven-3.5.4/ apache-maven/ 
cd /etc/profile.d/
sudo vim maven.sh
sudo export M2_HOME=/usr/local/src/apache-maven
sudo export PATH=${M2_HOME}/bin:${PATH}
sudo chmod +x maven.sh
sudo source /etc/profile.d/maven.sh
mvn --version