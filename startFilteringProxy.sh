#!/bin/sh
DOCKER_IMAGE_OWNER=cyclone
DOCKER_IMAGE_NAME=federated-filtering-proxy
FQDN=${FQDN:-$(              hostname -I | sed 's/ /\n/g' | grep -v 172.17 | head -n 1)}
TARGET_FQDN=${TARGET_FQDN:-$(hostname -I | sed 's/ /\n/g' | grep    172.17 | head -n 1)}
TARGET_PORT=${TARGET_PORT:-8080}
TARGET_PATH=${TARGET_PATH:-/Insyght/}
if [ -z "$1" ]
then
	DEFAULT_DEAMON_OR_ITERACTIVE=d
else
	DEFAULT_DEAMON_OR_ITERACTIVE=it
fi
DEAMON_OR_ITERACTIVE=${DEAMON_OR_ITERACTIVE:-$DEFAULT_DEAMON_OR_ITERACTIVE}
SUDO_CMD=${SUDO_CMD:-sudo}
DOCKERFILE=${DOCKERFILE:-Dockerfile}
LOG_DIR=${LOG_DIR:-/var/log/httpd-federated-filtering-proxy}

if [ ! -d $LOG_DIR ]
then
	echo "LOG_DIR(=$LOG_DIR) is missing, creating it"
	$SUDO_CMD mkdir -p $LOG_DIR
fi

if [ "$(docker ps 1>/dev/null 2>/dev/null ; echo $?)" != "0" ]
then
	echo "Docker seems to not be running"
	$SUDO_CMD service docker start
fi

if [ "$ALLOWED_EMAIL_SPACE_SEPARATED_VALUES" != "" ]
then
    rm ./apache_groups
fi

echo $DOCKER_IMAGE_OWNER
echo $DOCKER_IMAGE_NAME
echo $FQDN
echo $TARGET_FQDN
echo $TARGET_PORT
echo $TARGET_PATH
echo $DEAMON_OR_ITERACTIVE
echo $SUDO_CMD
echo $ALLOWED_EMAIL_SPACE_SEPARATED_VALUES

if [ ! -e ./apache_groups ]
then

  #ALLOWED_EMAIL_COMMA_SEPARATED_VALUES=${ALLOWED_EMAIL_COMMA_SEPARATED_VALUES:-john.doe@no.where, bowie@space.oddity}
  if [ "$ALLOWED_EMAIL_SPACE_SEPARATED_VALUES" == "" ]
  then
    echo "env var \$ALLOWED_EMAIL_SPACE_SEPARATED_VALUES must contains edugain email of allowed user"
    exit 1
  fi
  echo "cyclone: $ALLOWED_EMAIL_SPACE_SEPARATED_VALUES" > apache_groups
fi



echo "to open $TARGET_PORT:\niptables -I INPUT 1 -p tcp -i docker0 -m tcp --dport $TARGET_PORT -j ACCEPT"

docker rm -f federated-filtering-proxy
docker build -t ${DOCKER_IMAGE_OWNER}/${DOCKER_IMAGE_NAME}  \
	-f ${DOCKERFILE} . &&  \
docker run -${DEAMON_OR_ITERACTIVE} -p 80:80 \
	-e FQDN=${FQDN}  \
	-e TARGET_FQDN=${TARGET_FQDN}  \
	-e TARGET_PORT=${TARGET_PORT} \
	-e TARGET_PATH=${TARGET_PATH} \
	-v ${LOG_DIR}:/var/log/httpd \
	-v $PWD/proxy.conf:/etc/httpd/conf.d/proxy.conf:ro \
	-v $PWD/proxy.conf:/etc/apache2/conf-enabled/proxy.conf:ro \
	-v $PWD/apache_groups:/etc/httpd/apache_groups:ro \
	--name ${DOCKER_IMAGE_NAME}  \
	${DOCKER_IMAGE_OWNER}/${DOCKER_IMAGE_NAME} $1

