#!/bin/bash

# get admin privileges
sudo su

# install httpd
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
echo "Welcome to DevOps Training" > /var/www/html/index.html



# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or via sudo."
  exit 1
fi

# --- CONFIGURATION ---
USERNAME="basituser"
SSH_PUBLIC_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCusIPz0lqpRlHSm0B1x7fvtRDbFqrmegAQmQ1Fo+OeXCaHdyL4dkWIjUNr2mg42QM0pkiyZ1ezs8/kIxim9iYBBByhxpuTXecjy996XalwnNo19h8PqNLyXq6Han9GN5u16+K4/+7eqFqGZnxlYt8RaibH35pMj6iumW+5YLTlU99uNtADH98Iat3xDpJjII4D8Ih+YNgrbo4BcQgtpiJPzN1HDPz84eWhe1Ljehe/51r/A07c3SbuUoSSB5wjGxeMKBkYSQfzIS2dDoGudxMHqVN9PX4EQBlQRiCApdIYjFrMiqJ36tNIytc4sw4SDVf7Rpr8W+w2rLDj4RiJWT/6pRO/dsc1uAvcIq5mOA03BII6RxnpSHQzpp7EJq9m54gEpceCMnrd4Wxez81AtIah5polhdS6YwwhIsiJ1FZoOvAxduaHpcMdFKWcNtooBIpcvljHkNPzYRLhK7AsuGyoyGtGlzkaIDMZjvfysezm1OJ3q85JghLsb1fnz25IyMU= rnbass99@Desktop-Bas2nd" # Replace with your actual public key
ADD_TO_SUDO=true  # Set to false if the user shouldn't have root access
# ---------------------

echo "Creating user: $USERNAME..."

# 1. Create the user with a home directory and bash shell
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists!"
else
    useradd -m -s /bin/bash "$USERNAME"
    echo "User $USERNAME created successfully."
fi

# 2. Configure SSH Directory and Public Key
USER_HOME="/home/$USERNAME"
SSH_DIR="$USER_HOME/.ssh"

mkdir -p "$SSH_DIR"
echo "$SSH_PUBLIC_KEY" > "$SSH_DIR/authorized_keys"

# Set strict permissions required by SSH
chmod 700 "$SSH_DIR"
chmod 600 "$SSH_DIR/authorized_keys"
chown -R "$USERNAME:$USERNAME" "$SSH_DIR"

echo "SSH key configured with correct permissions."

# 3. Optional: Add to sudo/wheel group based on OS distribution
if [ "$ADD_TO_SUDO" = true ]; then
    echo "Adding $USERNAME to sudoers..."
    
    # Check for Ubuntu/Debian 'sudo' group vs RHEL/Amazon Linux 'wheel' group
    if grep -q '^sudo:' /etc/group; then
        usermod -aG sudo "$USERNAME"
    elif grep -q '^wheel:' /etc/group; then
        usermod -aG wheel "$USERNAME"
    else
        echo "Warning: Could not find sudo or wheel group. Manual assignment required."
    fi
    
    # Optional: Allow passwordless sudo (matches default EC2 user behavior)
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME"
    chmod 0440 "/etc/sudoers.d/$USERNAME"
    echo "Sudo access granted."
fi

echo "Setup complete! The user '$USERNAME' can now log in using their private key."