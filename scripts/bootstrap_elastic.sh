#!/bin/bash

#Fail fast (Exit immediately if one command fails)
set -e

# fetch the debian package and corresponding SHA512
wget -P /opt https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-6.4.3.deb
wget -P /opt https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-6.4.3.deb.sha512

#install default jdk
sudo apt-get update
sudo apt-get -y install default-jdk

cd /opt
#verfiy checksum
shasum -a 512 -c elasticsearch-oss-6.4.3.deb.sha512

#install elasticsearch
sudo dpkg -i elasticsearch-oss-6.4.3.deb

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service

sleep 5

#setup elasticsearch.yml
echo "node.name: jaeger" >> /etc/elasticsearch/elasticsearch.yml
echo "network.host: 0.0.0.0" >> /etc/elasticsearch/elasticsearch.yml

sudo systemctl start elasticsearch.service
