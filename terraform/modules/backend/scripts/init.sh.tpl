#!/bin/bash
set -e

# Update and install dependencies
apt-get update -y
apt-get install -y curl git nginx

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
npm install -g pm2

# Clone the app
git clone https://github.com/adavidarevalo/David-Shop-Ecommerce.git /opt/app
cd /opt/app/server
npm install

# Create .env file
cat > .env <<EOF
MONGODB_URI='${mongodb_uri}'
PORT=3000
JWT_SECRET='${jwt_secret}'
EOF

sudo npm run build

# Start the app with PM2
pm2 start npm --name "app" -- run start --env production
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

# Configure Nginx
cat > /etc/nginx/sites-available/app <<EOF_NGINX
server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF_NGINX

ln -sf /etc/nginx/sites-available/app /etc/nginx/sites-enabled/app
rm -f /etc/nginx/sites-enabled/default
systemctl restart nginx
