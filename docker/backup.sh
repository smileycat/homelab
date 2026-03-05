#!/bin/bash
source $HOME/homelab/docker/.env

backup_dir="$SYNC_PATH/Backup"
date=$(date +%Y-%m-%d)

##### Vaultwarden backup #####
mkdir -p $backup_dir/vaultwarden
docker stop vaultwarden
tar -czvf $backup_dir/vaultwarden/vw-$date.tar.gz -C $DOCKER_VOL vaultwarden
docker start vaultwarden
# keep only last 7 backups
ls -1t "$backup_dir"/vaultwarden/vw-*.tar.gz | tail -n +8 | xargs -r rm --