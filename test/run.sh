#!/bin/bash

export SUFFIX=${GO_PIPELINE_COUNTER}
if [ -z ${SUFFIX} ];then
    export SUFFIX=$(date +%s)
fi
if [ -z ${BUILD_IMG_NAME} ];then
    export BUILD_IMG_NAME=qnib/kopf
fi

#echo "## pull stack"
#docker-compose pull |grep Status
echo "## start stack"
docker-compose up -d

echo "# Sleep 20sec"
sleep 20

echo -n ">>> How many critical services are present in consul? => "
FAIL_CNT=$(docker exec -t consul curl http://localhost:8500/v1/health/state/critical |jq ". |length")
if [ ${FAIL_CNT} -eq 0 ];then
    echo "${FAIL_CNT} [OK]"
else
    echo "${FAIL_CNT} [FAIL]"
    docker exec -t consul curl http://localhost:8500/v1/health/state/critical |jq "."
    exit 1
fi
echo -n ">>> How many failing services are present in consul? => "
FAIL_CNT=$(docker exec -t consul curl http://localhost:8500/v1/health/state/failing |jq ". |length")
if [ ${FAIL_CNT} -eq 0 ];then
    echo "${FAIL_CNT} [OK]"
else
    echo "${FAIL_CNT} [FAIL]"
    docker exec -t consul curl http://localhost:8500/v1/health/state/failing |jq "."
    exit 1
fi
echo -n ">>> How many passing services are present in consul? => "
PASS_CNT=$(docker exec -t consul curl http://localhost:8500/v1/health/state/passing |jq ". |length")
echo "${PASS_CNT}"


if [ -z ${KEEP_STACK} ];then
    ./stop.sh
fi
