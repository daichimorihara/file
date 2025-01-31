#!/bin/bash
STORE_ID=d-95676b643f
PROFILE=nealle
USER_ID=e704aad8-f011-70ba-0c91-a7d4ee805a3c
# GROUP_ID=e7945a98-a051-70d2-9105-3874c246e1d0 # Developer
GROUP_ID=0714aac8-b011-70de-73a7-7f50785d0630 # DBAccessDevAndStg
aws identitystore create-group-membership --output json \
  --identity-store-id "${STORE_ID}" \
  --group-id "${GROUP_ID}" \
  --member-id UserId="${USER_ID}" \
  --profile "${PROFILE}"