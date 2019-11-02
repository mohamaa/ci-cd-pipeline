#!/usr/bin/env bash

echo 'The following commands install Maven to run Maven-built Java application'

wget http://mirrors.wuchna.com/apachemirror/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz

sudo mkdir -p /opt/maven
sudo tar -xvzf apache-maven-3.6.0-bin.tar.gz -C /opt/maven/ --strip-components=1
sudo ln -s /opt/maven/bin/mvn /usr/bin/mvn
mvn --version