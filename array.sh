#!/bin/bash

aws stepfunctions start-execution \
--state-machine-arn arn:aws:states:ap-northeast-1:131151490157:stateMachine:test-feat-notification \
--input '{"githubActions": "failure", "owner": "daichimorihara", "runId": "test", "repoName": "nealle/park-direct-front-customer-pc", "name": "customer-pc"}' \
--profile pd





