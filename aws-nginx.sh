#!/bin/bash
ENV=dev
PROFILE_NAME=biz

TASK_ID=$(aws ecs list-tasks \
  --region ap-northeast-1 \
  --cluster ecscluster-pd-biz-"$ENV" \
  --service-name ecsservice-pd-biz-"$ENV"-web \
  --desired-status RUNNING \
  --launch-type FARGATE \
  --query "taskArns[0]" \
  --output text \
  --profile "$PROFILE_NAME" |
  cut -d "/" -f 3)

aws ecs execute-command \
  --region ap-northeast-1 \
  --cluster ecscluster-pd-biz-"$ENV" \
  --container web --interactive \
  --command sh \
  --task "$TASK_ID" \
  --profile "$PROFILE_NAME"



