#!/bin/bash

usage() { 
	echo "Usage: $0 [-p]";
	echo -e "\t-p : Unsets proxy for docker";
	exit 1;
}

# Set proxy for docker
SET_PROXY=1

while getopts "p" opt; do
  case $opt in
    p)
      echo "Removing proxy for docker!" 
	  SET_PROXY=0
      ;;
    *)
      usage
      ;;
  esac
done

shift $((OPTIND-1))

PROXY="<PUTPOXY>"

USER_DOCKER_CONFIG="${HOME}/.docker/config.json"

DOCKER_SYSTEMD_PROXY_PATH="/etc/systemd/system/docker.service.d"
DS_PROXY_FILE="${DOCKER_SYSTEMD_PROXY_PATH}/proxy.conf"

TMP_JSON="/tmp/tmp.json"

if ! which jq &>/dev/null; then 
    echo "[ERORR] install jq or update manually: ${USER_DCOKER_CONFIG} !" 
else
    echo "[INFO] Modifying ${USER_DOCKER_CONFIG}"
    if [ ! -d ~/.docker ]; then
        mkdir ~/.docker
    fi
    if [ ! -f ${USER_DOCKER_CONFIG} ]; then
        echo "{ }" > ${USER_DOCKER_CONFIG}
    fi

    if [ ${SET_PROXY} -eq 1 ]; then
        jq '. += {"proxies":{"default":{"httpProxy":"'${PROXY}'","httpsProxy":"'${PROXY}'"}}}' <${USER_DOCKER_CONFIG} >${TMP_JSON} && mv ${TMP_JSON} ${USER_DOCKER_CONFIG}

    else
        jq 'del(.proxies)' <${USER_DOCKER_CONFIG} >${TMP_JSON} && mv ${TMP_JSON} ${USER_DOCKER_CONFIG}
    fi
fi

# docker service proxy file for pull images command
echo "[INFO] Modifying ${DS_PROXY_FILE}"


if [ ${SET_PROXY} -eq 1 ]; then
    if [ ! -d ${DOCKER_SYSTEMD_PROXY_PATH} ]; then
        sudo mkdir -p ${DOCKER_SYSTEMD_PROXY_PATH}
    fi
sudo tee ${DS_PROXY_FILE} >/dev/null <<EOF
[Service]
Environment="HTTP_PROXY=${PROXY}"
EOF

else
    sudo rm -f ${DS_PROXY_FILE}
fi

echo "[INFO] Restart docker.service"
sudo systemctl daemon-reload
sudo systemctl restart docker
