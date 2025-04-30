#!/bin/bash

yum -y install httpd
systemctl start httpd
systemctl enable httpd
#echo "This is project for Vaish College for branch name ${BRANCH_NAME}" > /var/www/html/index.html
mv /home/ec2-user/project-code/* /var/www/html/