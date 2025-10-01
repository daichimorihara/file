#!/bin/bash

# TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM4NjY5MDM3LCJpYXQiOjE3Mzg2NTQ2MzcsImp0aSI6ImFhZTcyYzkwZGY5MzQzYTliMWM4ODk4N2U5MjVkNGI2IiwidXNlcl9pZCI6MX0.lpmk5JdKuGGo5y8wpdEM_5CkLtviSrU-IhobaVLAoLA # ECS dev
TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM5MzU2NjAyLCJpYXQiOjE3MzkzNDIyMDIsImp0aSI6IjYwYjk5ZGM1ZTA0NjQ4Mzc5NjgwYWZkMGNmNDlkMzMzIiwidXNlcl9pZCI6MX0.06TNxBSu9almsTJVL7s2sA0WFH8714OXi3o-cuYksKM # Beanstalk dev

curl -X GET "https://biz-api-dev.park-direct.jp/api/v1/contract/?contract_kind__in=0,1,2,3&management_state__in=1&ordering=id&page=1" \
     -H "Authorization: JWT ${TOKEN}"