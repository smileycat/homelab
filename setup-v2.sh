#!/bin/bash
# Run this AFTER the Proxmox Docker VM Script
# For environment variables like DOCKER_VOL, please see homelab/docker/.env
user=
timezone=
cockpit_domain=

# 1. System Settings
echo 'bind '"'"'"\e[A": history-search-backward'"'"'' >>~/.bashrc
echo 'bind '"'"'"\e[B": history-search-forward'"'"'' >>~/.bashrc
timedatectl set-timezone $timezone
echo "SystemMaxUse=100M" | tee -a /etc/systemd/journald.conf
echo "MaxRetentionSec=30d" | tee -a /etc/systemd/journald.conf
systemctl restart systemd-journald

mkdir ~/.ssh ~/.certbot ~/docker-volume ~/docker-env
touch ~/.ssh/authorized_keys ~/.certbot/cloudflare.ini
chmod 600 ~/.ssh/authorized_keys ~/.certbot/cloudflare.ini
chmod 700 ~/.ssh ~/.certbot
mkdir /mnt/immich /mnt/lzr /mnt/share /mnt/backups

echo "fs.inotify.max_user_watches=65536" | tee -a /etc/sysctl.conf
sysctl -p

echo "# <source_tag>    <mount_point>   <type>  <options>   <dump>  <pass>
immich  /mnt/immich     virtiofs        defaults,_netdev,nofail  0  0
lzr     /mnt/lzr        virtiofs        defaults,_netdev,nofail  0  0
share   /mnt/share      virtiofs        defaults,_netdev,nofail  0  0
backups /mnt/backups    virtiofs        defaults,_netdev,nofail  0  0" | tee -a /etc/fstab > /dev/null

# 2. Add Cockpit & Apps (Debian 12 specific)
# for cockpit
. /etc/os-release
echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" | tee /etc/apt/sources.list.d/backports.list
curl -sSL https://repo.45drives.com/setup | bash

apt update
apt install -t ${VERSION_CODENAME}-backports cockpit
apt install certbot vim git openssh-server cloud-guest-utils python3-certbot-dns-cloudflare -y
apt install cockpit-file-sharing cockpit-identities cockpit-navigator -y

# 3. Wireguard Permission Helper
# apt install cron zfsutils-linux wireguard resolvconf -y # for penguin server
# useradd -rM -s /usr/sbin/nologin cron || true
# echo "cron ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart wg-quick*" | tee -a /etc/rs

# 4. Resize Root Partition
growpart /dev/sda 1
resize2fs /dev/sda1

# 6. Quality of life & Cockpit Contig
echo '''[WebService]
Origins = https://$cockpit_domain wss://$cockpit_domain
ProtocolHeader = X-Forwarded-Proto''' | tee /etc/cockpit/cockpit.conf > /dev/null

# 7. Download homelab repo
cd ~
git clone https://github.com/smileycat/homelab.git
chmod +x ~/homelab/moon-cli/scripts/*.sh
# TODO: need golang. 
# ~/homelab/moon-cli/scripts/install.sh

# 8. SSH
passwd -u root
echo "PasswordAuthentication no
ChallengeResponseAuthentication no
PubkeyAuthentication yes
PermitRootLogin yes
UsePAM no" | tee /etc/ssh/sshd_config.d/00-pubkey-auth.conf > /dev/null
systemctl enable ssh