DATE=$(date +\%Y_\%m_\%d_\%H_\%M_\%S)

CHUNK_SIZE=256M

sudo rclone copy --verbose --drive-chunk-size ${CHUNK_SIZE} /home/exo/ rover-backup:/Jetson-TX2/Backups/EXO/EXO-${DATE}/