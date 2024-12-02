labels=('[feature] clmgt' '[feature] customer')
repos=(park-direct-front-client park-direct-front-customer)
workflow_ids=(deploy_feature_environments.yaml  deploy_feature_environments.yml)

echo "${labels[*]}"
if [[ "${labels[*]}" == *"[feature] clmgt"* ]]; then
    echo "Include"
else
    echo "not included"
fi

# for ((i = 0; i <= 1; i++)); do
#     label=${labels[$i]}
#     REPO=${repos[$i]}
#     WORKFLOWS_ID=${workflow_ids[$i]}
#     echo "$label $REPO $WORKFLOWS_ID"
# done