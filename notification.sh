#!/bin/bash

aws amplify list-jobs --app-id ds8fqxi9ffvsl --branch-name feature/CLGB-1283 --profile pd | jq -r '.jobSummaries[0].status'

aws amplify list-jobs --app-id d2wzedstaugsnh --branch-name develop --profile pd | jq -r '.jobSummaries[0].status'

$.DescribeDbClusters.DbClusters[0].Status == "Failed"

$.listJobs.jobSummaries[0].status


owner
appId
branchFullName
recordURL
branchFirstName
branchLastName

{
    "owner": "",
    "appId": "",
    "branchFullName": "",
    "recordURL": "",
    "branchFirstName": "",
    "branchLastName": ""
}
