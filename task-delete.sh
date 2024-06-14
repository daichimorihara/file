#!/bin/bash

families=($(aws ecs list-task-definition-families --family-prefix ecs-task-definition-pd-feat- --status INACTIVE --profile pd | jq -r '.families[]'))

for family in "${families[@]}"; do
    aws ecs list-task-definitions --family-prefix "$family" --status INACTIVE --profile pd | \
    jq -r '.taskDefinitionArns[]' | \
    xargs -I {} aws ecs delete-task-definitions --task-definitions {} --profile pd
done
