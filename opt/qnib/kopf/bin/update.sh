#!/bin/bash

source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv elasticsearch

consul-template -consul localhost:8500 -wait 5s -template "/etc/consul-templates/nginx.conf.ctmpl:/etc/nginx/nginx.conf:supervisorctl restart nginx"
