#!/bin/bash
docker_vol=/mnt/data/docker-volume
# src1=$docker_vol/immich/library
# src2=$docker_vol/immich/upload
# src3=$docker_vol/immich/profile
dest=$docker_vol/immich/backups
date=$(date +%Y-%m-%d)
dbbackupPath=$dest/postgres-$date.sql.gz

# mkdir -p $dest

# backup immich db
docker exec -t immich-postgres pg_dumpall \
    --clean \
    --if-exists \
    --username=postgres | gzip >"$dbbackupPath"
# backup immich assets
# rsync -av --delete $src1 $src2 $src3 $dest

# restore db backup
# docker compose down -v  # CAUTION! Deletes all Immich data to start from scratch.
# docker compose create   # Create Docker containers for Immich apps without running them.
# docker start immich-postgres    # Start Postgres server
# sleep 10    # Wait for Postgres server to start up
# gunzip --stdout "$dbbackupPath" \
#     | sed "s/SELECT pg_catalog.set_config('search_path', '', false);/SELECT pg_catalog.set_config('search_path', 'public, pg_catalog', true);/g" \
#     | docker exec -i immich-postgres psql --dbname=postgres --username=postgres  # Restore Backup
# docker compose up -d    # Start remainder of Immich apps