#!/bin/sh
# execute this s

go build -o build/moon-v2 main.go
sudo systemctl stop moon-v2
sudo cp build/moon-v2 /usr/local/bin/moon-v2
sudo systemctl daemon-reload
sudo systemctl start moon-v2