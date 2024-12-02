#!/bin/bash


task_definitions=("ecs-task-definition-pd-feat-SRE-1777-backend-batch" "ecs-task-definition-pd-feat-SRE-1777-backend-migration" "ecs-task-definition-pd-feat-SRE-1777-backend-web" "ecs-task-definition-pd-feat-SRE-1777-backend-worker")
for task_def in "${task_definitions[@]}"; do
    aws ecs list-task-definitions --family-prefix "$task_def" --profile pd | jq -r '.taskDefinitionArns[]' | \
    xargs -I {} aws ecs deregister-task-definition --task-definition {} --profile pd
done

for task_def in "${task_definitions[@]}"; do
    aws ecs list-task-definitions --family-prefix "$task_def" --status INACTIVE --profile pd | \
    jq -r '.taskDefinitionArns[]' | \
    xargs -I {} aws ecs delete-task-definitions --task-definitions {} --profile pd
done