#!/bin/sh
# baux-scale-server-install.sh
# Automated installation script for BAUX scale server on FreeBSD
# Run as root after initial VM setup

set -e

echo "BAUX Scale Server Installation Script"
echo "====================================="

# Install required packages
echo "Installing packages..."
pkg update
pkg install -y headscale doas git neovim

# Configure doas for badlandz user
echo "Configuring doas..."
echo "permit badlandz as root" > /usr/local/etc/doas.conf

# Create headscale config directory
echo "Setting up Headscale configuration..."
mkdir -p /etc/headscale
cp /usr/local/etc/headscale/config.yaml /etc/headscale/config.yaml

# Configure Headscale for HTTPS with Let's Encrypt
cat >> /etc/headscale/config.yaml << EOF
server_url: https://bs.coseismic.org
listen_addr: 0.0.0.0:443
acme_email: robert.current@gmail.com
acme_url: https://acme-v02.api.letsencrypt.org/directory
tls_letsencrypt_hostname: bs.coseismic.org
tls_letsencrypt_cache_dir: /var/lib/headscale/cache
EOF

# Create headscale user and group
pw groupadd headscale 2>/dev/null || true
pw useradd headscale -g headscale -d /var/lib/headscale -s /usr/sbin/nologin 2>/dev/null || true

# Create cache directory
mkdir -p /var/lib/headscale/cache
chown headscale:headscale /var/lib/headscale/cache

# Generate private key
echo "Generating Headscale private key..."
headscale generate private-key

# Enable and start service
echo "Starting Headscale service..."
sysrc headscale_enable=YES
service headscale start

# Wait for service to start
sleep 5

# Create user and preauth key
echo "Creating Headscale user and preauth key..."
headscale users create baux-mesh
PREAUTH_KEY=$(headscale preauthkeys create -e 24h --user 1 | grep -o ' [a-zA-Z0-9]\{32\}')
echo "Preauth key: $PREAUTH_KEY"

# Create badlandz user if not exists
if ! id badlandz > /dev/null 2>&1; then
    echo "Creating badlandz user..."
    pw useradd badlandz -m -s /bin/sh
fi

# Set up SSH for badlandz
mkdir -p /home/badlandz/.ssh
cp /root/.ssh/authorized_keys /home/badlandz/.ssh/ 2>/dev/null || true
chown -R badlandz:badlandz /home/badlandz/.ssh
chmod 700 /home/badlandz/.ssh
chmod 600 /home/badlandz/.ssh/authorized_keys

# Clone RoxieOS repo
echo "Cloning RoxieOS repository..."
su - badlandz -c "git clone https://github.com/badlandz/RoxieOS.git ~/src/RoxieOS"

echo "Installation complete!"
echo "Preauth key for client enrollment: $PREAUTH_KEY"
echo "Next steps:"
echo "1. Test HTTPS: curl -I https://bs.coseismic.org"
echo "2. Enroll clients: tailscale up --login-server https://bs.coseismic.org --auth-key $PREAUTH_KEY"