#!/bin/bash
# set -x
my_array=("ecs-task-definition-pd-feat-SRE-1744-backend-batch" "ecs-task-definition-pd-feat-SRE-1744-backend-migration")
for ((i = 0; i <= 1; i++)); do
    length=$(aws ecs list-task-definitions --family-prefix ${my_array[$i]} --profile pd | jq '.taskDefinitionArns' | jq 'length')
    arn_array=$(aws ecs list-task-definitions --family-prefix ${my_array[$i]} --profile pd | jq -r ".taskDefinitionArns")
    for ((j = 0; j <= $length - 1; j++)); do  
        arn=$(echo $arn_array | jq -r ".[$j]")
        # aws ecs deregister-task-definition --task-definition "$arn"
        echo $arn
    done 
done

