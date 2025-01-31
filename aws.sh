#!/bin/bash
ENV=feat
NAME=feature-SRE-3746
PROFILE_NAME=pd

TASK_ID=$(aws ecs list-tasks \
  --region ap-northeast-1 \
  --cluster ecscluster-pd-"$ENV" \
  --service-name ecsservice-pd-"$NAME"-web \
  --desired-status RUNNING \
  --launch-type FARGATE \
  --query "taskArns[0]" \
  --output text \
  --profile "$PROFILE_NAME" |
  cut -d "/" -f 3)

aws ecs execute-command \
  --region ap-northeast-1 \
  --cluster ecscluster-pd-"$ENV" \
  --container nginx --interactive \
  --command bash \
  --task "$TASK_ID" \
  --profile "$PROFILE_NAME"