#!bin/bash
user=polarbear

# Next two lines mean the user cron can do the "systemctl restart wg-quick*" command without a password
sudo useradd -rM -s /usr/sbin/nologin cron
echo "cron ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart wg-quick*" | sudo tee -a /etc/sudoers

. /etc/os-release
curl -sSL https://repo.45drives.com/setup | sudo bash # cockpit plugin repo
sudo apt update
sudo apt install certbot vim git acpid rsync qemu-guest-agent python3-certbot-dns-cloudflare -y
sudo apt install -t ${VERSION_CODENAME}-backports cockpit # ubuntu
sudo apt install cockpit-file-sharing cockpit-identities cockpit-navigator cockpit-zfs-manager
# sudo apt install cron zfsutils-linux wireguard resolvconf -y # for penguin server
sudo systemctl enable acpid
sudo systemctl start acpid
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent

# Add cron job to restart wireguard every 6 hours; for penguin server
# (sudo crontab -l 2>/dev/null; echo "0 */6 * * * systemctl restart wg-quick@polarbear") | sudo crontab -

# chmod +x $HOME/homelab/backup.sh
# (crontab -l 2>/dev/null; echo "0 2 * * * $HOME/homelab/backup.sh") | crontab -

######### INSTALL DOCKER, NODE #########
# Add Docker's official GPG key, and repository to Apt
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add Node's GPG key, and repository to Apt
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin nodejs -y
sudo usermod -aG docker $user
############ END INSTALL ############

echo 'export DOCKER_VOL=$HOME/docker-volume' >>~/.bashrc
echo 'export DOCKER_ENV=$HOME/docker-env' >>~/.bashrc
echo 'export BACKUP_PATH=/mnt/data/sync/Backup' >>~/.bashrc
echo 'bind '"'"'"\e[A": history-search-backward'"'"'' >>~/.bashrc
echo 'bind '"'"'"\e[B": history-search-forward'"'"'' >>~/.bashrc

echo '''[WebService]
Origins = https://cockpit.smileyfam.me wss://cockpit.smileyfam.me
ProtocolHeader = X-Forwarded-Proto''' | sudo tee /etc/cockpit/cockpit.conf > /dev/null
