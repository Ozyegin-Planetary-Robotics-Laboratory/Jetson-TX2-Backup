DATE=$(date +\%Y_\%m_\%d_\%H_\%M_\%S)
CHUNK_SIZE=256M
LOG_PATH="/home/exo/Jetson-TX2-Backup/Backups"
LOG_FILE="${LOG_PATH}/BACKUP_${DATE}.log"
mkdir -p ${LOG_PATH}
exec > >(tee -a ${LOG_FILE})
exec 2>&1

# Function to log messages with timestamp
log() {
  echo "$(date +\%Y-\%m-\%d_\%H:\%M:\%S) $1"
}
START_TIME=$(date +%s)
log "Backup started at: $(date +\%Y-\%m-\%d_\%H:\%M:\%S)"

sudo rclone copy --verbose --drive-chunk-size ${CHUNK_SIZE} /home/exo/ backup:/Jetson-TX2/Backups/EXO/EXO-${DATE}/

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
  echo "Backup Status: Successful" >> ${LOG_FILE}
  echo "Start Time: $START_TIME" >> ${LOG_FILE}
  echo "End Time: $END_TIME" >> ${LOG_FILE}
  echo "Duration: $(date -u -d @$DURATION +\%H:\%M:\%S)" >> ${LOG_FILE}
  echo "Total Space Backed Up: $BACKED_UP_SPACE" >> ${LOG_FILE}
else
  log "Backup failed."
  echo "Backup Status: Failed" > ${LOG_FILE}
fi

#copy log file to a drive then delete it. 
rclone copy ${LOG_FILE} backup:/Jetson-TX2/Backups/EXO/EXO-${DATE}/
rm ${LOG_FILE}
