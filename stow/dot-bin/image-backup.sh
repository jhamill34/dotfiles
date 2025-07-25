#!/bin/bash

# Docker Image Backup Script for Colima Restart
# This script saves all Docker images to tar files and provides a restore script

set -e

BACKUP_DIR="${HOME}/docker-backup-$(date +%Y%m%d-%H%M%S)"
RESTORE_SCRIPT="${BACKUP_DIR}/restore_images.sh"

echo "Creating backup directory: ${BACKUP_DIR}"
mkdir -p "${BACKUP_DIR}"

echo "Getting list of Docker images..."
images=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep -v "<none>")

if [ -z "$images" ]; then
    echo "No images found to backup"
    exit 0
fi

echo "Found $(echo "$images" | wc -l) images to backup"

# Create restore script header
cat > "${RESTORE_SCRIPT}" << 'EOF'
#!/bin/bash
# Auto-generated restore script
set -e

echo "Restoring Docker images..."
EOF

chmod +x "${RESTORE_SCRIPT}"

# Backup each image
counter=1
total=$(echo "$images" | wc -l)

echo "$images" | while read -r image; do
    if [ -n "$image" ]; then
        # Create safe filename
        safe_name=$(echo "$image" | sed 's/[^a-zA-Z0-9._-]/_/g')
        tar_file="${BACKUP_DIR}/${safe_name}.tar"

        echo "[$counter/$total] Backing up: $image"
        docker save "$image" -o "$tar_file"

        # Add to restore script
        echo "echo \"Restoring: $image\"" >> "${RESTORE_SCRIPT}"
        echo "docker load -i \"${tar_file}\"" >> "${RESTORE_SCRIPT}"

        counter=$((counter + 1))
    fi
done

echo ""
echo "Backup completed successfully!"
echo "Backup location: ${BACKUP_DIR}"
echo "To restore after restarting Colima, run: ${RESTORE_SCRIPT}"
echo ""
echo "You can now safely restart Colima with:"
echo "  colima stop"
echo "  colima start --network-address --network-host-addresses 0.0.0.0"
echo ""
echo "Backup size:"
du -sh "${BACKUP_DIR}"
