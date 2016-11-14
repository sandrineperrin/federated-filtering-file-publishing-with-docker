# federated-filtering-proxy-with-docker

```shell

export DEAMON_OR_ITERACTIVE=it
export ALLOWED_EMAIL_SPACE_SEPARATED_VALUES="john.doe@no.where bowie@space.oddity"

#If you experience problem durring httpd installation, use an container based on Centos image with:
export DOCKERFILE=Dockerfile

# Set service port
export SERVICE_PORT=8888

./startFilteringService.sh
```
