#!/bin/bash

echo "backend branch"
gh pr list --search 'is:open label:"[feature] backend","[feature] backend-ha"' --repo nealle/park-direct-backend --json 'headRefName' --jq '.[].headRefName'
printf "\n"

echo "RDS"
gh pr list --search 'is:open label:"[feature] db from dev","[feature] db from dev autoStart","[feature] db from prod","[feature] db from prod autoStart"' --repo nealle/park-direct-backend --json 'headRefName' --jq '.[].headRefName'
printf "\n"

echo "clmgt"
(gh pr list --search 'is:open label:"[feature] clmgt"' --repo nealle/park-direct-backend --json 'headRefName' --jq '.[].headRefName'; gh pr list --search 'is:open label:"[feature] clmgt","[feature] clmgt to dev"' --repo nealle/park-direct-front-client --json 'headRefName' --jq '.[].headRefName') | sort | uniq
printf "\n"

echo "customer"
(gh pr list --search 'is:open label:"[feature] customer"' --repo nealle/park-direct-backend --json 'headRefName' --jq '.[].headRefName'; gh pr list --search 'is:open label:"[feature] customer","[feature] customer to dev"' --repo nealle/park-direct-front-customer --json 'headRefName' --jq '.[].headRefName') | sort | uniq
printf "\n"

echo "customer-pc"
(gh pr list --search 'is:open label:"[feature] customer-pc"' --repo nealle/park-direct-backend --json 'headRefName' --jq '.[].headRefName'; gh pr list --search 'is:open label:"[feature] customer-pc","[feature] customer-pc to dev"' --repo nealle/park-direct-front-customer-pc --json 'headRefName' --jq '.[].headRefName') | sort | uniq
printf "\n"



