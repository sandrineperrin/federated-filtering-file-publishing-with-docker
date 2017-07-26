# federated-filtering-proxy-with-docker

Access to a local directory to parse content and download results files.

```shell

export DEAMON_OR_ITERACTIVE=it
export ALLOWED_EMAIL_SPACE_SEPARATED_VALUES="john.doe@no.where bowie@space.oddity"

#don't forget to adujst TARGET_FQDN, TARGET_PORT, and TARGET_PATH
export TARGET_PATH=/
export TARGET_PORT=8080
>>>>>>> 916f75b14c4a9742c5349c11eb6dd1cd2ac11f88

./startFilteringService.sh
```
