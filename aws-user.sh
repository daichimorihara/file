#!/bin/bash
STORE_ID=d-95676b643f
PROFILE=nealle

USER_ID=07a4bae8-b041-70c5-b65f-1d998a853923

# GROUP_ID=57942ab8-2051-70be-1a71-cece1343a1e4 # DataSuccess
# GROUP_ID=e7945a98-a051-70d2-9105-3874c246e1d0 # Developer
GROUP_ID=0714aac8-b011-70de-73a7-7f50785d0630 # DBAccessDevAndStg
# GROUP_ID=87844a78-6001-7066-b4f3-4979425632a4 # DBAccessProd
# GROUP_ID=2774bac8-a0e1-70ac-23e5-eb104d2fab22 # CustomerSuccess
# GROUP_ID=0754ea78-3001-70da-f245-2b2a359939b8 # ResourceWithPIOperator
# GROUP_ID=9764aa78-5041-70bf-6332-6cddf4a8845d # InfraDeveloper
# GROUP_ID=c7d47a58-8061-7031-bae1-b3aeea2b1f29 # BillingAnalysts
# GROUP_ID=d7b49a48-70f1-70be-9c3c-970a9173f429 # AdministratorAll



aws identitystore create-group-membership --output json \
  --identity-store-id "${STORE_ID}" \
  --group-id "${GROUP_ID}" \
  --member-id UserId="${USER_ID}" \
  --profile "${PROFILE}"
