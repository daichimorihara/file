#!/bin/bash

arr=("cancellation-contract-tool"
"contract-download-tool-for-switch"
"corp-recruit-site"
"foodpass-customer"
"nealle-corporate-site"
"nealle-corporate-site-tool"
"park-direct-amazon-connect-sam"
"park-direct-backend"
"park-direct-coupon-page"
"park-direct-custom-ccp"
"park-direct-datadog-terraform"
"park-direct-dev-tools"
"park-direct-front-client"
"park-direct-front-customer"
"park-direct-front-customer-pc"
"park-direct-japn"
"park-direct-lp"
"park-direct-lp-renewal"
"park-direct-pdbiz-lp"
"park-direct-redash-import-to-spreadsheets"
"park-direct-sam"
"park-direct-terraform"
"parking-pin-setting-for-googlemap-tool"
"parking-pin-setting-for-pd-tool"
"pd-biz-back"
"pd-biz-front"
"pd-export-to-pdbiz"
"pd-isp-contract"
"sales-list-scraping-tool"
"sms-batch-send-tool"
"takuto-isp-goweb-application"
"takuto-isp-goweb-property"
"tokusoku-request-notification-tool"
"uipath-package")

for word in "${arr[@]}"; do
    aws codecommit create-repository --repository-name "$word" --profile backup
done