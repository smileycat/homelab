#!/bin/sh
# execute this script from moonV2 root dir

go build -o build/moon-v2 main.go
sudo cp build/moon-v2 /usr/local/bin
sudo ln moon-v2.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl start moon-v2
sudo systemctl enable moon-v2
