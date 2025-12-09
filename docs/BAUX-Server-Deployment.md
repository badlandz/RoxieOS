# BAUX Server Deployment Guide
**Setting up Headscale Control Plane & Session Storage**

This deployment guide supports the core vision of BAUX-MESH infrastructure for USB boot to IDE on any system.

## Overview

BAUX Server provides the central hub for distributed session management, running Headscale (self-hosted Tailscale) and session storage. This guide covers deployment on cloud infrastructure using FreeBSD.

## Server Requirements

### Minimum Specifications (Baux-Scale)
- **CPU:** 1 vCPU (Headscale lightweight + drop-baux sync)
- **RAM:** 1GB (50MB Headscale + 200-500MB registry/drop-baux)
- **Storage:** 50-100GB SSD (25GB base + 25-75GB drop-baux session data)
- **Bandwidth:** 1TB/month (coordination + drop-baux syncs)
- **OS:** FreeBSD 15.0-RELEASE (thin jail for isolation)
- **Network:** Static public IP with domain (hs.coseismic.org)
- **Cost:** $5-10/month (Vultr 1GB plan)

### Recommended Hosting
**Vultr Cloud Compute ($6-12/month):**
- 1 vCPU, 1GB RAM, 25GB SSD, 1TB bandwidth
- Excellent FreeBSD support
- Multiple global datacenters
- 24/7 support

**Alternatives:** DigitalOcean or Linode with FreeBSD images

## FreeBSD Installation

### Base System Setup
1. **Download FreeBSD 15.0-RELEASE ISO**
2. **Boot Installation Media**
3. **Follow Standard Installation:**
   - Keymap: US (will be overridden by BAUX)
   - Hostname: baux-server
   - Partitioning: Auto ZFS
   - Root password: Set strong password
   - Network: DHCP (configure static later)
   - System hardening: Enable

### Post-Installation Configuration
```bash
# Update system
freebsd-update fetch install
pkg update && pkg upgrade

# Install essential packages
pkg install bash git neovim tmux htop

# Configure static IP (replace with your values)
echo 'ifconfig_em0="inet 192.168.1.100 netmask 255.255.255.0"' >> /etc/rc.conf
echo 'defaultrouter="192.168.1.1"' >> /etc/rc.conf
echo 'nameserver 1.1.1.1' >> /etc/resolv.conf

# Reboot to apply network changes
reboot
```

## Headscale Installation

### Package Installation
```bash
# Add Headscale repository
mkdir -p /usr/local/etc/pkg/repos
echo 'headscale: { url: "https://pkg.headscale.dev/freebsd/main" }' > /usr/local/etc/pkg/repos/headscale.conf

# Install Headscale
pkg install headscale
```

### Configuration
```bash
# Generate config
headscale config --output /usr/local/etc/headscale/config.yaml

# Edit configuration
vi /usr/local/etc/headscale/config.yaml
```

**Key Configuration Settings:**
```yaml
server_url: https://hs.coseismic.org
listen_addr: 0.0.0.0:8080
metrics_listen_addr: 127.0.0.1:9090
grpc_listen_addr: 127.0.0.1:50443
grpc_allow_insecure: false

# Database
db_type: sqlite3
db_path: /var/db/headscale.db

# DNS
magic_dns: true
base_domain: internal

# Logging
log_level: info
```

### SSL Certificate Setup
```bash
# Install acme.sh for Let's Encrypt
pkg install acme.sh

# Generate certificate
acme.sh --issue -d hs.coseismic.org --webroot /usr/local/www/headscale/

# Install certificate
acme.sh --install-cert -d hs.coseismic.org \
  --key-file /usr/local/etc/headscale/key.pem \
  --fullchain-file /usr/local/etc/headscale/cert.pem
```

### Service Configuration
```bash
# Enable Headscale service
sysrc headscale_enable=YES

# Start service
service headscale start

# Verify running
headscale version
headscale nodes list
```

## Domain & DNS Setup

### Domain Configuration
1. **Purchase Domain:** coseismic.org (or your preferred domain)
2. **DNS Records:**
   - A record: hs.coseismic.org → [server IP]
   - Optional: CAA records for Let's Encrypt

### Reverse Proxy (Optional)
```bash
# Install nginx
pkg install nginx

# Configure SSL termination
# (nginx config for headscale web interface)
```

## BAUX Server Components

### Session Registry & Drop-Baux Setup
```bash
# Create registry and drop-baux storage
mkdir -p /var/db/baux/registry /var/db/baux/drop-baux
chmod 700 /var/db/baux

# Install required packages
pkg install sqlite3 rsync openssh-portable  # For drop-baux peer syncing
```

#### Self-Preservation Features
- **Automated Backups**: Cron jobs for registry/drop-baux data (rsync to offsite)
- **Monitoring**: htop/sysutils/htop for resource tracking
- **Crash Recovery**: tmux resurrect for maintenance sessions; ZFS snapshots if applicable
- **Updates**: Quarterly pkg updates with testing

### BAUX Server Package
```bash
# Install BAUX server components
pkg install baux-server

# Configure
vi /usr/local/etc/baux/server.conf
```

**Server Configuration:**
```bash
# Headscale integration
HEADSCALE_URL=https://hs.coseismic.org
HEADSCALE_API_KEY=your-api-key

# Session registry (location tracking only)
REGISTRY_DB=/var/db/baux/registry.db
MAINTENANCE_SESSIONS_DIR=/var/db/baux/maintenance

# Network settings
LISTEN_ADDR=0.0.0.0:8443
TLS_CERT=/usr/local/etc/baux/cert.pem
TLS_KEY=/usr/local/etc/baux/key.pem
```

### Service Startup
```bash
# Enable BAUX server
sysrc baux_server_enable=YES
service baux-server start
```

## Security Hardening

### Firewall Configuration
```bash
# Install pf
sysrc pf_enable=YES

# Basic pf.conf
cat > /etc/pf.conf << EOF
ext_if="em0"

# Headscale ports
headscale_ports = "{ 80 443 8080 }"

# BAUX server ports
baux_ports = "{ 8443 }"

# Allow SSH, HTTP, HTTPS, Headscale, BAUX
pass in on \$ext_if proto tcp to port { 22 80 443 } keep state
pass in on \$ext_if proto tcp to port \$headscale_ports keep state
pass in on \$ext_if proto tcp to port \$baux_ports keep state

# Default deny
block all
EOF

# Enable firewall
pfctl -f /etc/pf.conf
service pf start
```

### SSH Hardening
```bash
# Disable password authentication
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Use key-only authentication
# (Add your public key to ~/.ssh/authorized_keys)

# Restart SSH
service sshd restart
```

### Monitoring Setup
```bash
# Install monitoring
pkg install net-mgmt/netdata

# Configure basic monitoring
sysrc netdata_enable=YES
service netdata start
```

## Client Enrollment

### Generate Enrollment Key
```bash
# Create pre-auth key for clients
headscale preauthkeys create --reusable --expiration 24h --tags tag:baux-client
```

### Client Setup Instructions
```bash
# On client device
# Install headscale client
pkg install headscale

# Register with server
headscale register --server https://hs.coseismic.org --key <preauth-key>

# Accept on server
headscale nodes approve <node-name>
```

## Backup & Recovery

### Automated Backups
```bash
# Install backup tools
pkg install rsync

# Create backup script
cat > /usr/local/bin/baux-backup << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d)
BACKUP_DIR="/var/backups/baux"

# Backup Headscale database
sqlite3 /var/db/headscale.db ".backup ${BACKUP_DIR}/headscale-${DATE}.db"

# Backup registry data
sqlite3 /var/db/baux/registry.db ".backup ${BACKUP_DIR}/registry-${DATE}.db"

# Backup local maintenance sessions
rsync -a /var/db/baux/maintenance/ ${BACKUP_DIR}/maintenance-${DATE}/

# Cleanup old backups (keep 7 days)
find $BACKUP_DIR -name "*.db" -mtime +7 -delete
find $BACKUP_DIR -name "maintenance-*" -mtime +7 -delete
EOF

chmod +x /usr/local/bin/baux-backup
```

### Cron Automation
```bash
# Add to crontab
echo "0 2 * * * root /usr/local/bin/baux-backup" >> /etc/crontab
```

## Troubleshooting

### Headscale Issues
```bash
# Check service status
service headscale status

# View logs
tail -f /var/log/headscale.log

# Test connectivity
curl https://hs.coseismic.org/health
```

### Network Problems
```bash
# Check firewall rules
pfctl -s rules

# Test connectivity
ping hs.coseismic.org
nslookup hs.coseismic.org
```

### Certificate Issues
```bash
# Renew Let's Encrypt
acme.sh --renew -d hs.coseismic.org

# Reload services
service headscale restart
service baux-server restart
```

## Scaling Considerations

### Vertical Scaling
- **CPU:** Upgrade to 2 vCPU for increased registry throughput
- **RAM:** 2GB for larger device registries
- **Storage:** 50GB for extended registry history

### Horizontal Scaling
- **Multiple Servers:** Geographic distribution of registries
- **Load Balancing:** Distribute registry queries
- **Database Replication:** Registry synchronization across servers

## Maintenance

### Updates
```bash
# Update FreeBSD
freebsd-update fetch install

# Update packages
pkg update && pkg upgrade

# Update Headscale
pkg upgrade headscale
service headscale restart
```

### Monitoring
- **System Resources:** htop, systat
- **Network Traffic:** iftop, nload
- **Service Health:** Check Headscale web interface
- **Registry Activity:** Monitor BAUX server logs and registry queries

## Conclusion

A properly configured BAUX server provides the foundation for distributed session management. Start with the minimum RackNerd VPS configuration and scale as your needs grow.

**Next Steps:**
1. Complete Headscale setup and testing
2. Enroll your first client device
3. Test session location registry
4. Implement peer-to-peer session sync
5. Implement backup automation

**References:**
- [Headscale Installation](https://headscale.net/stable/setup/install/)
- [FreeBSD Server Setup](https://www.youtube.com/watch?v=r-qn6DrJ6IA)
- [Vultr Cloud Compute](https://www.vultr.com/pricing/#cloud-compute)