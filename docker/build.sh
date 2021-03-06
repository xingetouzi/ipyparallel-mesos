#! /bin/bash -xe

DOCKER_REGISTRY=registry.fxdayu.com
DOCKER_TAG=$1

docker build -t ${DOCKER_REGISTRY}/ipyparallel-marathon-controller:${DOCKER_TAG} -f ./Dockerfile.controller .
docker build -t ${DOCKER_REGISTRY}/ipyparallel-marathon-engine:${DOCKER_TAG} -f ./Dockerfile.engine .

if [ "$DOCKER_TAG" == "dev" ]; then
    echo "dev build. not shipping"
else
    sudo docker push ${DOCKER_REGISTRY}/ipyparallel-marathon-controller:${DOCKER_TAG}
    sudo docker push ${DOCKER_REGISTRY}/ipyparallel-marathon-engine:${DOCKER_TAG}
fi
