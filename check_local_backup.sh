#!/usr/bin/bash

# Source directories for backup
personal_files="/home/my-user"
www_files="/var/www"

# Encrypted backup destination
BU_dir="/var/backups/local-backup"
latest_data_BU="${BU_dir}/latest"
weekly_BU="${BU_dir}/weekly"
monthly_BU="${BU_dir}/monthly"

# List encrypted file structure of backup folders
echo "Monthly:"
ls "${monthly_BU}" -l --block-size=1000000
echo "Weekly:"
ls "${weekly_BU}" -l --block-size=1000000
echo "Latest:"
ls "${latest_data_BU}" -l

# List clear file structure of backup folders
echo "Backups root directory:"
sudo rclone lsd LocalSysCrypt:
echo "Backup of personal directory:"
sudo rclone lsl LocalSysCrypt:/personal-backup
echo "Backup of www directory:"
sudo rclone lsl LocalSysCrypt:/www-backup

# Check consistency for latest files from personal directory
echo "Check of personal directory backup:"
sudo rclone cryptcheck "${personal_files}" \
    LocalSysCrypt:/personal-backup

# Check consistency for latest files from /var/www directory
echo "Check of www directory backup:"
sudo rclone cryptcheck "${www_files}" \
    LocalSysCrypt:/www-backup