# federated-filtering-proxy-with-docker

Access to a local directory to parse content and download results files.

```shell

export DEAMON_OR_ITERACTIVE=it
export ALLOWED_EMAIL_SPACE_SEPARATED_VALUES="john.doe@no.where bowie@space.oddity"

#If you experience problem durring httpd installation, use an container based on Centos image with:
export DOCKERFILE=Dockerfile

# Set service port
export SERVICE_PORT=8888
export SITE=<directory_path>

./startFilteringService.sh
```
