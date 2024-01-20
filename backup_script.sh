DATE=$(date +\%Y_\%m_\%d_\%H_\%M_\%S)

CHUNK_SIZE=256M

mkdir -p /home/exo/Backups

# Redirect stdout and stderr to a log file
LOG_FILE="/home/exo/Backups/BACKUP_${DATE}.log"
exec > >(tee -a ${LOG_FILE})
exec 2>&1

# Function to log messages with timestamp
log() {
  echo "$(date +\%Y-\%m-\%d_\%H:\%M:\%S) $1"
}
START_TIME=$(date +%s)
log "Backup started at: $(date +\%Y-\%m-\%d_\%H:\%M:\%S)"

# Compress the home directory using RAR
rar a -r /home/exo/Backups/home_directory.rar /home/exo/

sudo rclone copy --verbose --drive-chunk-size ${CHUNK_SIZE} /home/exo/Backups/ rover-backup:/Jetson-TX2/Backups/EXO/EXO-${DATE}/

END_TIME=$(date +%s)

# Check if the backup was successful
if [ $? -eq 0 ]; then
  log "Backup completed successfully."
  log "Backup finished at: $(date +\%Y-\%m-\%d_\%H:\%M:\%S)"

  # Calculate and log the duration of the backup
  DURATION=$((END_TIME - START_TIME))
  log "Backup duration: $(date -u -d @$DURATION +\%H:\%M:\%S)"

  # Calculate and log the total space backed up
  BACKED_UP_SPACE=$(sudo du -sh /home/exo/ | cut -f1)
  log "Total space backed up: $BACKED_UP_SPACE"

  # Create a summary log file
  SUMMARY_LOG="/home/exo/Backups/BACKUP_${DATE}.log"
  echo "Backup Status: Successful" >> ${SUMMARY_LOG}
  echo "Start Time: $START_TIME" >> ${SUMMARY_LOG}
  echo "End Time: $END_TIME" >> ${SUMMARY_LOG}
  echo "Duration: $(date -u -d @$DURATION +\%H:\%M:\%S)" >> ${SUMMARY_LOG}
  echo "Total Space Backed Up: $BACKED_UP_SPACE" >> ${SUMMARY_LOG}
else
  log "Backup failed."
  echo "Backup Status: Failed" > ${SUMMARY_LOG}
fi
