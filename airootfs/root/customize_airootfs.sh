#!/bin/bash

# Create live user
useradd -m -G wheel -s /bin/bash liveuser
echo "liveuser:live" | chpasswd
echo "root:root" | chpasswd

# Set up sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Enable NetworkManager
systemctl enable NetworkManager

# Configure auto-login for liveuser with proper environment
mkdir -p /etc/systemd/system/getty@tty1.service.d/
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'EOL'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty -o '-p -f -- \\u' --noclear --autologin liveuser %I $TERM
Environment=XDG_RUNTIME_DIR=/run/user/1000
EOL

# Set proper permissions for XDG runtime
mkdir -p /run/user/1000
chown liveuser:liveuser /run/user/1000
chmod 700 /run/user/1000

