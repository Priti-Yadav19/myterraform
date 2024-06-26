#!/bin/bash

# Update package lists
sudo apt-get update -y

# Install Apache
sudo apt-get install apache2 -y

# Enable Apache to start on boot
sudo systemctl enable apache2

# Start Apache service
sudo systemctl start apache2

# Check status of Apache service
sudo systemctl status apache2

echo "Apache installation completed."
