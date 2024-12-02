#!/bin/bash

webhookIDs=($(aws amplify list-webhooks --app-id ds8fqxi9ffvsl --profile pd | jq -r '.webhooks[].webhookId'))

for webhookId in "${webhookIDs[@]}"; do
    aws amplify delete-webhook --webhook-id "$webhookId" --profile pd
done