#!/bin/bash

families=($(aws ecs list-task-definition-families --family-prefix ecs-task-definition-pd-feat- --status ACTIVE --profile pd | jq -r '.families[]'))

using_now=("ecs-task-definition-pd-feat-CSG-668-backend-batch"
    "ecs-task-definition-pd-feat-CSG-668-backend-migration"
    "ecs-task-definition-pd-feat-CSG-668-backend-web"
    "ecs-task-definition-pd-feat-CSG-668-backend-worker")

for family in "${families[@]}"; do
    if [[ ${using_now[@]} =~ $family ]]; then
        continue
    fi
    aws ecs list-task-definitions --family-prefix "$family" --profile pd | jq -r '.taskDefinitionArns[]' | \
    xargs -I {} aws ecs deregister-task-definition --task-definition {} --profile pd
done
