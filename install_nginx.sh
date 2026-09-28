#!/bin/bash

sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl start httpd
sudo systemctl enable httpd

echo "<h1> Welcome to Nginx on EC2 >/h1>" | sudo tee /var/www/html/index.html