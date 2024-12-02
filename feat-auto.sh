#!/bin/bash

# Define an associative array for labels and repositories
declare -A queries=(
  ["backend"]="label:\"[feature] backend\",\"[feature] backend-ha\""
  ["RDS"]="label:\"[feature] db from dev\",\"[feature] db from dev autoStart\",\"[feature] db from prod\",\"[feature] db from prod autoStart\""
  ["clmgt"]="label:\"[feature] clmgt\""
  ["customer"]="label:\"[feature] customer\""
  ["customer-pc"]="label:\"[feature] customer-pc\""
)

# Define an associative array for repositories
declare -A repos=(
  ["backend"]="nealle/park-direct-backend"
  ["RDS"]="nealle/park-direct-backend"
  ["clmgt"]="nealle/park-direct-backend nealle/park-direct-front-client"
  ["customer"]="nealle/park-direct-backend nealle/park-direct-front-customer"
  ["customer-pc"]="nealle/park-direct-backend nealle/park-direct-front-customer-pc"
)

# Loop through the queries and repositories
for key in "${!queries[@]}"; do
  echo "$key"
  for repo in ${repos[$key]}; do
    gh pr list --search "is:open ${queries[$key]}" --repo $repo --json 'headRefName' --jq '.[].headRefName'
  done | sort | uniq
  printf "\n"
done
