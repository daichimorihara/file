#!/usr/bin/env bash

BASE_DIR=$(dirname $0)
ENV=dev
PRODUCT=pd
SERVICE=rds
ROLE=writer

# ANSI escape code
ESC=$(printf '\033')
RESET="${ESC}[0m"
GREEN="${ESC}[32m"
RED="${ESC}[31m"

main() {
    parse_args $@
    load_config
    if [[ "$PRODUCT" != "pdbiz" ]]; then
        fetch_running_bastion_task_arn
        if [[ -z "${TASK_ARN}" ]]; then
            launch_bastion
        fi
        make_target
    fi
    connect_with_ssm
}

parse_args() {
    for OPT in "$@"
    do
        case $1 in
            --local-port | --local-port=* )
                if [[ "$1" =~ ^--local-port= ]]; then
                    PORT_LOCAL=$(echo $1 | sed -e 's/^--local-port=//')
                elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                    echo "'$1' option requires one more argument (port number)."
                    exit 1
                else
                    PORT_LOCAL="$2"
                    shift
                fi
                ;;

            --profile | --profile=* )
                if [[ "$1" =~ ^--profile= ]]; then
                    export AWS_PROFILE=$(echo $1 | sed -e 's/^--profile=//')
                elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                    echo "'$1' option requires one more argument (AWS profile)."
                    exit 1
                else
                    export AWS_PROFILE=$2
                    shift
                fi
                ;;

            --region | --region=* )
                if [[ "$1" =~ ^--region= ]]; then
                    export AWS_REGION=$(echo $1 | sed -e 's/^--region=//')
                elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                    echo "'$1' option requires one more argument (AWS region)."
                    exit 1
                else
                    export AWS_REGION=$2
                    shift
                fi
                ;;

            --env | --env=* )
                if [[ "$1" =~ ^--env= ]]; then
                    ENV=$(echo $1 | sed -e 's/^--env=//')
                elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                    echo "'$1' option requires one more argument (env)."
                    exit 1
                else
                    ENV=$2
                    shift
                fi
                ;;

            --product | --product=* )
                if [[ "$1" =~ ^--product= ]]; then
                    PRODUCT=$(echo $1 | sed -e 's/^--product=//')
                elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                    echo "'$1' option requires one more argument (product)."
                    exit 1
                else
                    PRODUCT=$2
                    shift
                fi
                ;;

            --service | --service=* )
                if [[ "$1" =~ ^--service= ]]; then
                    SERVICE=$(echo $1 | sed -e 's/^--service=//')
                elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                    echo "'$1' option requires one more argument (service)."
                    exit 1
                else
                    SERVICE=$2
                    shift
                fi
                ;;

            --role | --role=* )
                if [[ "$1" =~ ^--role= ]]; then
                    ROLE=$(echo $1 | sed -e 's/^--role=//')
                elif [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                    echo "'$1' option requires one more argument (role)."
                    exit 1
                else
                    ROLE=$2
                    shift
                fi
                ;;

            --help | -h )
                echo "Makes port forwarding (localhost):(ECS task):(RDS/Redis instance) with SSM."
                echo "Note that This SSM connections (uses SSM document) is limited by 1 hours, So this port forwarding is limited by it."
                echo ""
                echo "USAGE: forward.sh (options...) <DB/Redis INSTANCE>"
                echo ""
                echo "  target host: RDS/Redis instance's hostname."
                echo "  instance id: The ID of EC2 instance used as port forwarding."
                echo ""
                echo ""
                echo "OPTIONS:"
                echo "  --local-port [port] : Available localhost's port number (default: 35432/36379)."
                echo "    (alias):              --local-port=[port], -lp [port], -lp=[port]"
                echo "  --profile [profile] : Set AWS Profile (i.e. set AWS_PROFILE, default is unset)."
                echo "    (alias):              --profile=[profile]"
                echo "  --region [region]   : AWS Region (i.e. set AWS_REGION, default: ap-northeast-1)."
                echo "    (alias):              --region=[region]"
                echo "  --env [env]         : Environment  (default: dev, select 'dev', 'stg' or 'prod')."
                echo "    (alias):              --env=[env]"
                echo "  --product [product] : Product identifier  (default: pd, select 'pd', 'pdbiz' or 'pcc')."
                echo "    (alias):              --product=[product]"
                echo "  --service [service] : Serivce identifier  (default: rds, select 'rds', 'redis')."
                echo "    (alias):              --service=[service]"
                echo "  --role [role]       : Service role  (default: writer, select 'reader', 'writer')."
                echo "    (alias):              --role=[role]"
                exit 0
                ;;

            -* )
                echo "Invalid option '$1'"
                echo "Please run it: 'forward.sh --help'"
                exit 1
                ;;
            "" )
                ;;
        esac
        shift
    done
}

load_config() {
    case "${PRODUCT}" in
        "pd")
            source ${BASE_DIR}/config/pd_config.sh
            ;;
        "pdbiz")
            source ${BASE_DIR}/config/pdbiz_config.sh
            ;;
        "pcc")
            source ${BASE_DIR}/config/pcc_config.sh
            ;;
    esac
}

fetch_running_bastion_task_arn() {
    local task_arns
    task_arns=($(aws ecs list-tasks --cluster ${ECS_CLUSTER} --query "taskArns" --output text))

    local running_task_arn=""
    for task_arn in "${task_arns[@]}"
    do
        local group
        group=$(aws ecs describe-tasks --cluster ${ECS_CLUSTER} --task ${task_arn} --query "tasks[].group" --output text)

        if [[ "$group" =~ ^family:.* ]]; then
            TASK_ARN=$task_arn
            break
        fi
    done
}

launch_bastion() {
    local task_definition_revision
    task_definition_revision=$(aws ecs describe-task-definition --task-definition ${ECS_TASK_DEFINITION} --query "taskDefinition.revision")

    local task_arn
    task_arn=$(aws ecs run-task \
        --capacity-provider-strategy capacityProvider=FARGATE_SPOT,weight=1 \
        --cluster ${ECS_CLUSTER} \
        --count 1 \
        --enable-execute-command \
        --network-configuration "awsvpcConfiguration={subnets=[${ECS_VPC_SUBNET_ID}],securityGroups=[${ECS_SECURITY_GROUP_ID}],assignPublicIp=DISABLED}" \
        --task-definition ${ECS_TASK_DEFINITION}:${task_definition_revision} \
        --query "tasks[0].taskArn" \
        --output text)

    echo "${GREEN}Bastion container is starting... Please wait a moment.${RESET}"
    for i in {1..10} ; do
        echo -n "." && sleep 3

        local status
        status=$(aws ecs describe-tasks --cluster ${ECS_CLUSTER} --tasks ${task_arn} --query "tasks[0].lastStatus" --output text)

        if [ "${status}" == "RUNNING" ]; then
            echo -e "\n${GREEN}Bastion container is running!${RESET}\n"
            break
        elif [ $i -eq 10 ]; then
            echo -e "\n${RED}Bastion container failed to start. Please try again${RESET}" >&2
            exit 1
        fi
    done
    TASK_ARN=$task_arn
}

make_target() {
    local runtime_id
    runtime_id=$(aws ecs describe-tasks --cluster ${ECS_CLUSTER} --tasks ${TASK_ARN} --query "tasks[0].containers[0].runtimeId" --output text)
    
    local task_id
    task_id=$(echo "$runtime_id" | sed 's/-.*//')
    TARGET=ecs:${ECS_CLUSTER}_${task_id}_${runtime_id}
}

connect_with_ssm() {
    cmd="aws ssm start-session \
        --target ${TARGET} \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters '{\"host\": [ \"${HOST_REMOTE}\" ], \"portNumber\": [ \"${PORT_REMOTE}\" ], \"localPortNumber\": [ \"${PORT_LOCAL}\" ]}'"
    echo "${GREEN}${cmd}${RESET}"
    eval "$cmd"
}

main $@