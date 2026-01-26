#!/bin/bash

##### Vaultwarden backup #####
date=$(date +%Y-%m-%d)
mkdir -p $BACKUP_PATH/vaultwarden

docker stop vaultwarden
tar -czvf $BACKUP_PATH/vaultwarden/vw-$date.tar.gz -C $DOCKER_VOL vaultwarden
docker start vaultwarden

# keep only last 7 backups
ls -1t "$BACKUP_PATH"/vaultwarden/vw-*.tar.gz | tail -n +8 | xargs -r rm --