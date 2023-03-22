#! /bin/bash
# SRC: https://gist.github.com/hjbotha/f64ef2e0cd1e8ba5ec526dcd6e937dd7

# NEWLY ADDED BACKUP FUNCTIONALITY IS NOT FULLY TESTED YET, USE WITH CARE, ESPECIALLY DELETION
# Developed for DSM 6 - 7.0.1. Not tested on other versions.
# Steps to install
# Save this script in one of your shares
# Edit it according to your requirements
# Backup /usr/syno/share/nginx/ as follows:
# # cd /usr/syno/share/
# # tar cvfz $DOCKER_USER_DIR/.bak/nginx.bak.tar.gz nginx
# Run this script as root
# Reboot and ensure everything is still working
# If not, restore the backup and post a comment on this script's gist page
# If it did, schedule it to run as root at boot
#   through Control Panel -> Task Scheduler

DEFAULT_HTTP_PORT=80
DEFAULT_HTTPS_PORT=443

CUSTOM_HTTP_PORT=5080  # DO NOT USE 5000 as it creates a duplicate server config block in Nginx and pukes
CUSTOM_HTTPS_PORT=5443 # DO NOT USE 5001 as it creates a duplicate server config block in Nginx and pukes

if [ "$RESET_TO_DEFAULTS" == "true" ];  then
  # Reverse the port replacement logic in the mustache files to "reset"
  HTTP_PORT_TO_REPLACE=$CUSTOM_HTTP_PORT
  HTTPS_PORT_TO_REPLACE=$CUSTOM_HTTPS_PORT
  HTTP_NEW_PORT=$DEFAULT_HTTP_PORT
  HTTPS_NEW_PORT=$DEFAULT_HTTPS_PORT
  echo "Resetting ports to default ports..."
else
  # Default behavior is to update Nginx for DSM to use ports 5000 & 50001
  HTTP_PORT_TO_REPLACE=$DEFAULT_HTTP_PORT
  HTTPS_PORT_TO_REPLACE=$DEFAULT_HTTPS_PORT
  HTTP_NEW_PORT=$CUSTOM_HTTP_PORT
  HTTPS_NEW_PORT=$CUSTOM_HTTPS_PORT
  echo "Overriding default ports..."
fi

echo "Replacing port $HTTP_PORT_TO_REPLACE with $HTTP_NEW_PORT"
echo "Replacing port $HTTPS_PORT_TO_REPLACE with $HTTPS_NEW_PORT"
echo " "


if [ "$BACKUP_FILES" == "false" ]; then
  BACKUP_FILES=false
else
  # Default to backing up all modified files
  BACKUP_FILES=true
fi

BACKUP_DIR=${HOME}/.bak/free_ports/
DELETE_OLD_BACKUPS=false # change to true to automatically delete old backups.
KEEP_BACKUP_DAYS=365

DATE=$(date +%Y-%m-%d-%H-%M-%S)
CURRENT_BACKUP_DIR="$BACKUP_DIR/$DATE"

if [ "$BACKUP_FILES" == "true" ]; then
  mkdir -p "$CURRENT_BACKUP_DIR"
  cp -r /usr/syno/share/nginx/ "$CURRENT_BACKUP_DIR"
fi

if [ "$DELETE_OLD_BACKUPS" == "true" ]; then
  find "$BACKUP_DIR/" -type d -mtime +$KEEP_BACKUP_DAYS -exec rm -r {} \;
fi

# Replace ports as desired in mustache config files
sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$HTTP_PORT_TO_REPLACE\([^0-9]\)/\1$HTTP_NEW_PORT\2/" /usr/syno/share/nginx/*.mustache
sed -i "s/^\([ \t]\+listen[ \t]\+[]:[]*\)$HTTPS_PORT_TO_REPLACE\([^0-9]\)/\1$HTTPS_NEW_PORT\2/" /usr/syno/share/nginx/*.mustache

echo "Made these changes:"
diff /usr/syno/share/nginx/ $CURRENT_BACKUP_DIR 2>&1 | tee $CURRENT_BACKUP_DIR/changes.log
echo " "

echo "[ ] Updating Nginx..."
if grep -q 'majorversion="7"' "/etc.defaults/VERSION"; then
  nginx -s reload
  echo "[✔] Nginx reloaded!"
else
  if which synoservicecfg; then
    synoservicecfg --restart nginx
  else
    synosystemctl restart nginx
  fi
  echo "[✔] Nginx restarted!"
fi

exit 0

