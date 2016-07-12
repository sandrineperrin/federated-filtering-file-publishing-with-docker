#!/bin/sh
DOCKER_IMAGE_OWNER=cyclone
DOCKER_IMAGE_NAME=federated-filtering-proxy
FQDN=$(       hostname -I | sed 's/ /\n/g' | grep -v 172.17 | head -n 1)
TARGET_FQDN=$(hostname -I | sed 's/ /\n/g' | grep    172.17 | head -n 1)
TARGET_PORT=${TARGET_PORT:-8080}
TARGET_PATH=${TARGET_PATH:-Insyght/}
DEAMON_OR_ITERACTIVE=${DEAMON_OR_ITERACTIVE:-d}
SUDO_CMD=${SUDO_CMD:-sudo}

sudo mkdir -p /var/log/httpd-federated-filtering-proxy

sudo service docker start

if [ "$ALLOWED_EMAIL_COMMA_SEPARATED_VALUES" != "" ]
then
    rm ./apache_groups
fi

if [ ! -e ./apache_groups ]
then

  #ALLOWED_EMAIL_COMMA_SEPARATED_VALUES=${ALLOWED_EMAIL_COMMA_SEPARATED_VALUES:-john.doe@no.where, bowie@space.oddity}
  if [ "$ALLOWED_EMAIL_COMMA_SEPARATED_VALUES" == "" ]
  then
    echo "env var \$ALLOWED_EMAIL_COMMA_SEPARATED_VALUES must contains edugain email of allowed user"
    exit 1
  fi
  echo "cyclone: $ALLOWED_EMAIL_COMMA_SEPARATED_VALUES" > apache_groups
fi



echo "to open $TARGET_PORT:\niptables -I INPUT 1 -p tcp -i docker0 -m tcp --dport $TARGET_PORT -j ACCEPT"

docker rm -f federated-filtering-proxy
docker build -t ${DOCKER_IMAGE_OWNER}/${DOCKER_IMAGE_NAME}  \
	-f Dockerfile . &&  \
docker run -${DEAMON_OR_ITERACTIVE} -p 80:80 \
	-e FQDN=${FQDN}  \
	-e TARGET_FQDN=${TARGET_FQDN}  \
	-e TARGET_PORT=${TARGET_PORT} \
	-e TARGET_PATH=${TARGET_PATH} \
	-v /var/log/httpd-federated-filtering-proxy:/var/log/httpd   \
	--name ${DOCKER_IMAGE_NAME}  \
	${DOCKER_IMAGE_OWNER}/${DOCKER_IMAGE_NAME}

