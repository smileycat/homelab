#!/bin/bash
sudo systemctl stop moon-v2
sudo systemctl disable moon-v2

sudo rm /etc/systemd/system/moon.service
sudo rm -r /var/www/moon
sudo rm -r /var/log/moon