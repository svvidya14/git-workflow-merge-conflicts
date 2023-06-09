#!/bin/bash

# Update package details
#sudo apt update

# Upgrade installed packages (optional)
#sudo apt upgrade -y

# Check if Apache2 is installed
if ! dpkg -s apache2 >/dev/null 2>&1; then
  echo "Apache2 is not installed. Installing..."
  
  # Update package details
  sudo apt update
  
  # Install Apache2
  sudo apt install -y apache2
  
  # Start Apache2 service
  sudo service apache2 start
  
  echo "Apache2 has been installed and started."
else
  echo "Apache2 is already installed."
fi

# Check if Apache2 service is enabled
if systemctl is-enabled apache2 >/dev/null 2>&1; then
    echo "Apache2 service is already enabled."
else
    # Enable Apache2 service
    sudo systemctl enable apache2
    echo "Apache2 service has been enabled."
fi

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Installing..."

    # Update package details
    sudo apt update

    # Install AWS CLI
    sudo apt install -y awscli
	echo "AWS CLI has been installed successfully."
else
    echo "AWS CLI is already installed."
fi

# Set your name
your_name="Vidya"

# Set timestamp
timestamp=$(date '+%d%m%Y-%H%M%S')

s3_bucket=upgrad-vidya

# Set the source directory
source_dir="/var/log/apache2"

# Set the destination directory
destination_dir="/tmp"

# Create a temporary directory
temp_vidya=$(mktemp -d)

# Copy only .log files from the source directory to the temporary directory
find "$source_dir" -type f -name "*.log" -exec cp {} "$temp_vidya" \;

# Create the tar archive
tar -cf "$destination_dir/$your_name-httpd-logs-$timestamp.tar" -C "$temp_vidya" .

# Remove the temporary directory
rm -r "$temp_vidya"

# Print the path to the created tar archive
echo "Tar archive created: $destination_dir/$your_name-httpd-logs-$timestamp.tar"

# Create a tar archive of the file/directory 
tar -cf /tmp/${your_name}-httpd-logs-${timestamp}.tar /tmp

# Copy the tar archive to S3
aws s3 cp /tmp/${your_name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${your_name}-httpd-logs-${timestamp}.tar

