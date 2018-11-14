#!/bin/bash

set -e

#sleeping for a min or 2 to let bootstrap_jaeger complete

sleep 10

#setting jaeger backend storage to elasticsearch
export SPAN_STORAGE_TYPE="elasticsearch"

if [ "$#" -ne 1 ]; then
  echo "Please check input arguments"
  echo "usage jaeger_startup <elasticipaddr>"
  exit 1
fi

# skipping check to see if input is actual IP, must be done in future
# Assumuning that this script is only excecuted from terraform template

elastic_conn="http://$1:9200"

echo $elastic_conn > /home/ubuntu/elastic_conn.txt

cd /opt/jaeger-1.7.0-linux-amd64

nohup ./jaeger-collector --es.num-shards 1 --es.num-replicas 0 --es.server-urls $elastic_conn > jaeger_collector.log 2>&1 &

nohup ./jaeger-query --es.num-shards 1 --es.num-replicas 0 --es.server-urls $elastic_conn > jaeger_query.log 2>&1 &
