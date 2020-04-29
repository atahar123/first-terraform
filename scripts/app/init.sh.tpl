#!/bin/bash



echo "export DB_HOST='mongodb://${db_ip_mine}:27017/posts'" >> /home/ubuntu/.bashrc
export DB_HOST='mongodb://${db_ip_mine}:27017/posts'
cd /home/ubuntu/app
node seeds/seed.js
pm2 start app.js
