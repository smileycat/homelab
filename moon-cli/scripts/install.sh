#!/bin/sh
# execute this script from moonV2 root dir

go build -o build/moon main.go
sudo cp ./build/moon /usr/local/bin
