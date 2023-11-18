# Jetson TX2 Backup Script

## Overview
This script is designed to perform a monthly backup of the Jetson TX2 home directory to a remote location using [rclone](https://rclone.org/). The backup is scheduled through a cron job.
## Prerequisites
- [rclone](https://rclone.org/) must be installed on the Jetson TX2.
- Proper configuration of rclone, including the setup of a remote (e.g., Google Drive).
- ### Using rclone with Google Drive
   #### Overview
   [rclone](https://rclone.org/) is a command-line program to manage files on cloud storage. This README provides a basic guide on how to set up and use rclone with Google Drive.

   #### Prerequisites
   - [rclone](https://rclone.org/) installed on your local machine.
   - A Google account with Google Drive enabled.
   
   #### Installation
   1. Download and install rclone from the [official website](https://rclone.org/downloads/).
   2. Follow the installation instructions for your operating system.
   
   #### Configuration
   1. Open a terminal or command prompt.
   2. Run the following command to configure rclone:
       ```bash
       rclone config
       ```
   3. Follow the interactive setup process:
      - Choose `n` for a new remote.
      - Enter a name for the remote, e.g., `rover-backup`.
      - Choose `drive` for the storage type.
      - Choose `auto` for the client_id.
      - Choose `n` for headless use.
      - Open the provided URL in a web browser, log in to your Google account, and grant rclone access.
      - Copy the verification code and paste it into the terminal.
      - Choose `y` to confirm the configuration.
   
   #### Usage
   1. Copy files from your local machine to Google Drive:
       ```bash
       rclone copy /path/to/local/files rover-backup:/path/in/google/drive
       ```
   2. Copy files from Google Drive to your local machine:
       ```bash
       rclone copy rover-backup:/path/in/google/drive /path/to/local/destination
       ```
   3. Synchronize files between your local machine and Google Drive:
       ```bash
       rclone sync /path/to/local/files rover-backup:/path/in/google/drive
       ```
   
   #### Additional Options
   - Explore more rclone commands and options in the [official documentation](https://rclone.org/docs/).
   - Adjust bandwidth limits, chunk sizes, and other settings as needed.
   
   #### Notes
   - Regularly check the rclone documentation for updates and new features.


- The script assumes the Jetson TX2 home directory is located at `/home/exo/`.

## Usage
1. Open the terminal on your Jetson TX2. (Termius can be used to access Jetson TX2 terminal which uses SSH protocol.)
2. Navigate to the directory where the backup script is located.
3. Make the script executable if not already: `chmod +x backup_script.sh`.
4. Edit the script if needed, especially the `CHUNK_SIZE` variable.
5. Add a cron job to automate the backup. Example:
    ```bash
    # Open the crontab for editing
    crontab -e

    # Add the following line to run the script on the first day of every month.
    0 0 1 * * /path/to/backup_script.sh
    ```
   Save and exit.

## Configuration
- `CHUNK_SIZE`: Adjust the `CHUNK_SIZE` variable to set the size of data chunks transferred during the backup.
- Update the rclone remote (`rover-backup:/Jetson-TX2/Backups/EXO/`) as needed for your setup. A shared Google Drive is currently being used.
## Comments in the Script
```bash
# Capture the current date and time to be used for naming the backup folder
DATE=$(date +\%Y_\%m_\%d_\%H_\%M_\%S)

# Set the chunk size for rclone to transfer data in chunks of 256MB
CHUNK_SIZE=256M

# Use rclone to copy the contents of the Jetson TX2 home directory to the specified remote location
# --verbose: Enable verbose output for better logging.(Recommended due to the fact that backing up home directory operation might take time) 
# --drive-chunk-size: Set the chunk size for Google Drive backend
# /home/exo/: Source directory to be backed up
# rover-backup:/Jetson-TX2/Backups/EXO/EXO-${DATE}/: Destination remote directory
sudo rclone copy --verbose --drive-chunk-size ${CHUNK_SIZE} /home/exo/ rover-backup:/Jetson-TX2/Backups/EXO/EXO-${DATE}/
```
## Notes
- Ensure proper permissions for executing the script and writing to the backup destination.
- Regularly check the backup destination to verify the successful completion of backups.

