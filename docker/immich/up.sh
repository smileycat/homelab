#!/bin/bash
# sandy DZFouGU4Q6WrOcUrcNiaf2q03RLcJ1PZe0YTJ15bVRs
# my_key="IJrlGwBBWIF5Ga992o4O2Rs7faJJPymMlSLMNVGWyU"
fam_key="6t8sF8WL8vRyS7QkYL6nSChiHEDZpJnAUQqkenLbc"
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