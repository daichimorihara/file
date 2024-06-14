#!/bin/bash

cat tasktest.json | jq -r 

# cat $FEATURE_MIGRATION_TASK_DF | jq -r '.containerDefinitions[] | select(.name=="migration") .environment[] | select(.name=="DB_HOST") .name'
