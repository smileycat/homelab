mkdir dist
touch dist/index.mjs
sudo mkdir -p /var/www/moon
sudo mkdir -p /var/log/moon
sudo ln dist/index.mjs /var/www/moon/
sudo ln moon.service /etc/systemd/system/
