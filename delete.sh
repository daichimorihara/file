#!/bin/bash

aws identitystore create-group --profile nealle --cli-input-json '
{
    "IdentityStoreId": "d-95676b643f",
    "DisplayName": "<グループ名>",
    "Description": ""
}'
