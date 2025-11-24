# config/hooks/live/9999-roxanne-welcome.chroot
#!/bin/sh
cat >/usr/local/bin/baux-welcome <<'EOF'
#!/bin/sh
clear
dialog --colors --title " Roxanne Cyberdeck v0.1 " --yesno "\Z1You are already running in RAM.\nThis live image \Zbis the full OS.\n\n\
• Press \ZbENTER\ZB → keep using it live (fastest)\n\
• Press \ZbI\ZB → install to disk with persistence\n\
\nTo get a normal user + desktop apps later:\n    apt install baux-dev\n\n\
Continue live?" 0 0

case $? in
   0) exit 0 ;;           # ENTER → live forever
   1) calamares ;;        # I → launch installer (you’ll add calamares later or your own installer)
esac
EOF
chmod +x /usr/local/bin/baux-welcome

# Add to /etc/profile.d so it runs once on first boot
echo "/usr/local/bin/baux-welcome || true" >>/etc/profile.d/roxanne.sh
