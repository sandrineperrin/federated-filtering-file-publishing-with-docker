# federated-filtering-proxy-with-docker

```shell

export DEAMON_OR_ITERACTIVE=it
export ALLOWED_EMAIL_SPACE_SEPARATED_VALUES="john.doe@no.where bowie@space.oddity"

#If you experience problem durring httpd installation, use an container based on debien image with:
export DOCKERFILE=Dockerfile.debian

#don't forget to adujst TARGET_FQDN, TARGET_PORT, and TARGET_PATH
export TARGET_PATH=/

./startFilteringProxy.sh
```
