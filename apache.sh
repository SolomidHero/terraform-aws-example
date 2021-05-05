#!/bin/bash

# install apache
apt update
apt install apache2 -y

# make sure apache is started
systemctl start apache2
systemctl enable apache2