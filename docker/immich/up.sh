#!/bin/bash
# my_key=""
fam_key=""
key=$fam_key

year=$1
base_path=/mnt/media/photos/$year
rm -r "$base_path/**/._*"
readarray -t array < <(ls "$base_path")

immich login-key http://localhost:3001/api $key

for item in "${array[@]}"; do
    path="$base_path/$item"
    echo $path
    echo
    immich upload -h \
        --album "$path"
done

# immich upload -h \
#     --dry-run \
#     --album "$base_path"