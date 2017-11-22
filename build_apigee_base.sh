#!/bin/bash

read -p 'License path: ' license
read -p 'Username (software.apigee.com): ' user
read -sp 'Password (software.apigee.com): ' pwd

docker build -t apigee_base:1709 -f apigee_base/Dockerfile . --build-arg ftp_user=$user --build-arg ftp_pwd=$pwd --build-arg license_path=$license --no-cache
