#!/bin/bash
set -eux

prefix=("CSG-1097" "CSG-784" "CLGB-1280" "CSG-977" "CSG-1103" "CLGB-1280" "CSG-899")

for p in "${prefix[@]}"; do

    families=("ecs-task-definition-pd-feat-$p-backend-batch" "ecs-task-definition-pd-feat-$p-backend-migration" "ecs-task-definition-pd-feat-$p-backend-web" "ecs-task-definition-pd-feat-$p-backend-worker")

    for family in "${families[@]}"; do
        aws ecs list-task-definitions --family-prefix "$family" --status INACTIVE --profile pd | \
        jq -r '.taskDefinitionArns[]' | \
        xargs -I {} aws ecs delete-task-definitions --task-definitions {} --profile pd>/dev/null
        sleep 4
    done

done
