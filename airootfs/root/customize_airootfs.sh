#!/bin/bash

# Create live user
useradd -m -G wheel -s /bin/bash luarch
echo "luarch:luarch" | chpasswd
echo "root:root" | chpasswd

# Set up sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Enable NetworkManager
systemctl enable NetworkManager

# Configure auto-login for luarch with proper environment
mkdir -p /etc/systemd/system/getty@tty1.service.d/
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'EOL'
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty -o '-p -f -- \\u' --noclear --autologin luarch %I $TERM
EOL

# Auto start hyprland
cat > /home/luarch/.bash_profile << 'EOL'
#!/bin/bash
if [[ -z "$DISPLAY" && $(tty) == /dev/tty1 ]]; then
    sleep 1
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    exec Hyprland
fi
EOL

chown luarch:luarch /home/luarch/.bash_profile

