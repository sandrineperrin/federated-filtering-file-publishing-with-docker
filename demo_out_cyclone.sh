# /bin/bash

APACHE_GROUP=$HOME/apache_groups
export SERVICE_PORT=80


if [ ! -f $APACHE_GROUP ]; then
	echo "sandrine.perrin@france-bioinformatique.fr" > $APACHE_GROUP
fi


./startFilteringService.sh 


