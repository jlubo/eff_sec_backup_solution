#!/usr/bin/bash

# Find the process ID(s) of rsync process(es)
pids=$(pgrep rsync)

# Loop through the process IDs and send SIGTERM to the processes
for pid in ${pids}
do
    sudo kill -15 $pid
done

# Run script for backup on local storage
sudo /bin/bash create_local_backup.sh > backup.log

# Define parameters
BU_DIR_LOCAL="/var/backups/local-backup"
BU_DIR_REMOTE="/var/backups/remote-backup"
LOCAL_USER="luser"
REMOTE_USER="ruser"
REMOTE_ADDRESS="192.168.1.2"
REMOTE_PORT="1001"

# Send backup to remote server
sudo rsync -Pav --delete-before --force \
    -e "ssh -p $REMOTE_PORT -i /home/$LOCAL_USER/.ssh/id_rsa_backup_server" \
    $BU_DIR_LOCAL/latest/ \
    $REMOTE_USER@$REMOTE_ADDRESS:/media/backup_drive/remote/latest/ >> backup.log

# Get backup from remote server
sudo rsync -Pav --delete-before --force \
    -e "ssh -p $REMOTE_PORT -i /home/$LOCAL_USER/.ssh/id_rsa_backup_server" \
    $REMOTE_USER@$REMOTE_ADDRESS:/media/backup_drive/local/ \
    $BU_DIR_REMOTE/latest/ >> backup.log