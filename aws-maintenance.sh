#!/bin/bash

# aws cloudfront get-distribution-config \
#     --id E2GVV973YKD57A \
#     --output yaml > dist-config-dev.yaml \
#     --profile biz

aws cloudfront update-distribution \
    --id E2GVV973YKD57A \
    --cli-input-yaml file://dist-config.yaml \
    --profile biz