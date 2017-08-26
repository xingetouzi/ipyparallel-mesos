#!/bin/bash 

# 创建用户
set -e
if getent passwd ${USER_ID} > /dev/null ; then
  echo "${USER} (${USER_ID}) exists"
else
  echo "Creating user ${USER} (${USER_ID})"
  useradd -u ${USER_ID} -M -s $SHELL ${USER}
fi

# chown ${USER}:${USER} /home/${USER}

# Query marathon find host of ipython paralell controller
CONTROLLER_HOST=`curl $MARATHON_MASTER/v2/apps/$CONTROLLER_MARATHON_ID | jq -r '.app.tasks | .[0].host'`
echo $CONTROLLER_HOST
curl http://${CONTROLLER_HOST}:${CONTROLLER_CONFIG_PORT:-1235}/ipcontroller-engine.json --create-dirs -o /opt/profile_mesos/security/ipcontroller-engine.json
cat /opt/profile_mesos/security/ipcontroller-engine.json
sudo -E PATH=${PATH} -E IPYTHONPATH=${IPYTHONPATH} -u ${USER} -E CONDA_ENVS_PATH:${CONDA_ENVS_PATH} \
source deactivate && \
source activate ${CONDA_DEFAULT_ENV} && \
ipengine --profile=mesos --url=tcp://$HOST:$PORT
