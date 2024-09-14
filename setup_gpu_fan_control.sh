#!/bin/bash

# Define default path or use user-specified path
INSTALL_DIR="${1:-$HOME}"

# Copy the GPU fan control script to the installation directory
echo "Copying gpu_fan_control.sh to $INSTALL_DIR"
cp gpu_fan_control.sh "$INSTALL_DIR"
chmod +x "$INSTALL_DIR/gpu_fan_control.sh"

# Create the systemd service file for the current user
SERVICE_FILE="/etc/systemd/system/nvidia-fan-control.service"

echo "Creating systemd service at $SERVICE_FILE"
sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Custom NVIDIA Fan Control Service
After=network.target

[Service]
Type=simple
ExecStart=$INSTALL_DIR/gpu_fan_control.sh c
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOL

# Enable and start the systemd service
echo "Enabling and starting the nvidia-fan-control service"
sudo systemctl daemon-reload
sudo systemctl enable nvidia-fan-control.service
sudo systemctl start nvidia-fan-control.service

echo "GPU fan control setup complete. Service is running."
