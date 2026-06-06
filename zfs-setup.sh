#!/bin/sh

zfs set compression=lz4 atime=off xattr=sa acltype=posixacl zdata
zfs create -o recordsize=128k -o compression=lz4 -o atime=off zdata/share
zfs create -o recordsize=1M -o compression=lz4 -o atime=off zdata/backups

zfs create -o recordsize=128k -o compression=lz4 -o atime=off zdata/immich
zfs create -o recordsize=1M zdata/immich/upload
zfs create -o recordsize=1M zdata/immich/library
zfs create -o recordsize=1M zdata/immich/backups
zfs create -o recordsize=1M zdata/immich/encoded-video
zfs create -o recordsize=128k zdata/immich/thumbs

zfs create -o recordsize=1M -o compression=lz4 -o atime=off zdata/lzr
zfs create zdata/lzr/Music
zfs create zdata/lzr/Movies
zfs create zdata/lzr/TV
zfs create -o recordsize=128k zdata/lzr/Idols
