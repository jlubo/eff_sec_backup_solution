#!/usr/bin/bash

# Source directories to backup
personal_files="/home/my-user"
www_files="/var/www"

# Encrypted backup destination
BU_dir="/var/backups/local-backup"
latest_data_BU="${BU_dir}/latest"
weekly_BU="${BU_dir}/weekly"
monthly_BU="${BU_dir}/monthly"

# Check if it is the day of the month to store a monthly backup (the 1st)
# and if so, store the backup from last week as monthly backup
now=$(date +"%d")
if [ ${now} == "01" ]
then # new month
    cp "${weekly_BU}"/* "${monthly_BU}"/
    echo "Monthly backup stored"
fi

# Check if it is the day of the week to store a weekly backup (Monday)
# and if so, create tar of the backup from previous day and store it as
# weekly backup; only keeping this single weekly backup
now=$(date +"%u")
if [ ${now} == 1 ]
then # new week
    cd "${latest_data_BU}"
    bufile=backup_`date +"%Y-%m-%d"`.tar
    rm -R -f "${weekly_BU}"/*
    tar -cf "${weekly_BU}/${bufile}" *
    echo "Weekly backup stored"
fi

# Save the rclone version in an unencrypted file to facilitate later
# restoring
sudo rclone version > "${latest_data_BU}/rclone_version.txt"

# Encrypt and sync latest files from personal directory
sudo rclone sync "${personal_files}" LocalSysCrypt:/personal-backup

# Encrypt and sync latest files from www directory
sudo rclone sync "${www_files}" LocalSysCrypt:/www-backup

# Finish
echo "Current data copied"