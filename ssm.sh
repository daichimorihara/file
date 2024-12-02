#!/bin/bash
cd /etc/nginx/conf.d/
sudo sh -c "sed s/uat\-cus[^\/]/<task-id>-cus.feat./ ./uat-cus.conf > ./<task-id>-cus.conf"
sudo systemctl reload nginx 



cd /etc/nginx/conf.d/;ll
sudo sh -c "sed s/uat\-cus[^\/]/<task-id>-cus.feat./ ./uat-cus.conf > ./<task-id>-cus.conf";ll
sudo systemctl reload nginx 