#!/bin/bash

sudo systemctl stop moon-v2
sudo systemctl disable moon-v2

sudo rm /usr/local/bin/moon-v2
sudo rm /etc/systemd/system/moon-v2.sh