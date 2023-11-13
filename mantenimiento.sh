sudo systemctl start mysqld

sudo systemctl start httpd

sudo systemctl list-units --type=service | grep mysql
