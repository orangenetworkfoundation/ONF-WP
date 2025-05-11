#!/bin/sh
# ONF-WP v1.0.4 Entrypoint Script
# Runs as root to set up WordPress, then execs PHP-FPM (which runs as 'wodby').

set -e # Exit immediately if a command exits with a non-zero status.

WP_ROOT="/var/www/html"
WP_CONFIG_PATH="${WP_ROOT}/wp-config.php"
WP_CONFIG_SAMPLE_PATH="/tmp/wp-config-onf-sample.php" # Copied by php.Dockerfile
ONF_WP_VERSION_ENV=$(printenv ONF_WP_VERSION || echo "1.0.4") # Read from Dockerfile ENV

# --- Initial Sanity Checks (Running as root) ---
if [ ! -d "${WP_ROOT}" ]; then
    echo "ONF-WP ERROR: WordPress root ${WP_ROOT} (bind mount target) does not exist. Cannot proceed." >&2
    exit 1
fi
if [ ! -f "${WP_CONFIG_SAMPLE_PATH}" ]; then
    echo "ONF-WP ERROR: wp-config sample ${WP_CONFIG_SAMPLE_PATH} not found. Image may be misconfigured." >&2
    exit 1
fi
echo "ONF-WP: Initializing WordPress environment in ${WP_ROOT} (v${ONF_WP_VERSION_ENV})..."

# --- Configure wp-config.php (if it doesn't exist) ---
if [ ! -f "${WP_CONFIG_PATH}" ]; then
    echo "ONF-WP: wp-config.php not found. Creating from sample..."
    cp "${WP_CONFIG_SAMPLE_PATH}" "${WP_CONFIG_PATH}"
    if [ $? -ne 0 ]; then
        echo "ONF-WP ERROR: Failed to copy sample wp-config.php to ${WP_CONFIG_PATH}." >&2
        exit 1
    fi
    echo "ONF-WP: Copied ${WP_CONFIG_SAMPLE_PATH} to ${WP_CONFIG_PATH}."

    echo "ONF-WP: Fetching new security salts for wp-config.php..."
    SALTS_OUTPUT=""
    SALTS_OUTPUT=$(curl -fsS --connect-timeout 5 --retry 3 --retry-delay 2 https://api.wordpress.org/secret-key/1.1/salt/)
    CURL_EXIT_CODE=$?

    if [ ${CURL_EXIT_CODE} -eq 0 ] && [ -n "${SALTS_OUTPUT}" ]; then
        echo "ONF-WP: Fetched salts successfully. Replacing placeholders in ${WP_CONFIG_PATH}."
        echo "${SALTS_OUTPUT}" > /tmp/salts.txt
        # Using awk for robust replacement
        awk '
          BEGIN { slurp = 0; replaced = 0 }
          /\/\*\*#@\+\// {
            if (replaced == 0) {
              while ((getline salt_line < "/tmp/salts.txt") > 0) { print salt_line };
              slurp = 1; replaced = 1;
            } else { print }
          }
          /\/\*\*#@-\*\// { slurp = 0; if (replaced == 1 && slurp == 0) { next } else { print } }
          { if (slurp == 0) print }
        ' "${WP_CONFIG_PATH}" > "${WP_CONFIG_PATH}.tmp" && mv "${WP_CONFIG_PATH}.tmp" "${WP_CONFIG_PATH}" || \
        echo "ONF-WP WARNING: Failed to replace salts in wp-config.php using awk. Default placeholders remain." >&2
        rm -f /tmp/salts.txt
    else
        echo "ONF-WP WARNING: Could not fetch salts from WordPress.org API (curl exit code: ${CURL_EXIT_CODE}). Using default placeholders." >&2
    fi
    echo "ONF-WP: wp-config.php configured."
else
    echo "ONF-WP: wp-config.php already exists at ${WP_CONFIG_PATH}. Skipping configuration."
fi

# --- Ensure WordPress Core Files Exist (Download if necessary) ---
if [ ! -f "${WP_ROOT}/wp-includes/version.php" ]; then
    echo "ONF-WP: WordPress core files not found in ${WP_ROOT}. Attempting to download..."
    if php -d memory_limit=512M /usr/local/bin/wp core download --path="${WP_ROOT}" --locale="en_US" --version="latest" --allow-root; then
        echo "ONF-WP: WordPress core downloaded successfully."
    else
        echo "ONF-WP ERROR: Failed to download WordPress core. See WP-CLI errors above." >&2
        echo "             Please check internet connection or manually place WordPress files in './wordpress' and restart." >&2
    fi
else
    echo "ONF-WP: WordPress core files found in ${WP_ROOT}."
fi

# --- Directory and Permission Adjustments (Still as root) ---
echo "ONF-WP: Ensuring key wp-content directories exist..."
mkdir -p \
    "${WP_ROOT}/wp-content" \
    "${WP_ROOT}/wp-content/themes" \
    "${WP_ROOT}/wp-content/plugins" \
    "${WP_ROOT}/wp-content/uploads" \
    "${WP_ROOT}/wp-content/uploads/fonts" \
    "${WP_ROOT}/wp-content/upgrade"

echo "ONF-WP: Attempting to set ownership of ${WP_ROOT} to wodby:wodby..."
# This chown is best-effort for bind mounts. Its success depends on host OS and Docker version.
if chown -R wodby:wodby "${WP_ROOT}"; then
    echo "ONF-WP: Ownership of ${WP_ROOT} preliminarily set to wodby:wodby."
else
    echo "ONF-WP WARNING: Failed to set full ownership of ${WP_ROOT} to wodby:wodby. This is common on Windows/macOS Docker Desktop due to host filesystem restrictions." >&2
fi

echo "ONF-WP: Applying development-friendly permissions to ${WP_ROOT} to enable WordPress self-management..."
# For local development, make the entire WordPress installation writable by the PHP user (wodby)
# from the container's perspective. This allows one-click updates, plugin/theme installs, etc.
# These permissions are applied by root before PHP-FPM (as wodby) starts.

# Set directories to 777: owner rwx, group rwx, other rwx (allows wodby user to write even if not owner/group)
# Set files to 666: owner rw, group rw, other rw (allows wodby user to write even if not owner/group)
# This is a pragmatic choice for local development ease on systems where UID/GID mapping is complex (Windows/macOS).
find "${WP_ROOT}" -type d -exec chmod 777 {} \;
find "${WP_ROOT}" -type f -exec chmod 666 {} \;

# Ensure wp-config.php specifically is also writable by wodby (covered by 666 above),
# but we can re-affirm ownership intent for clarity if needed, though chmod is key here.
if [ -f "${WP_CONFIG_PATH}" ]; then
    chown root:wodby "${WP_CONFIG_PATH}" 2>/dev/null || chown root "${WP_CONFIG_PATH}" 2>/dev/null || true # Best effort for group
    chmod 666 "${WP_CONFIG_PATH}" || echo "ONF-WP WARNING: Could not set permissions for ${WP_CONFIG_PATH} to 666." >&2
    echo "ONF-WP: Permissions for ${WP_CONFIG_PATH} set to allow writes by PHP user (wodby) for plugin compatibility (e.g. WP_CACHE)."
fi

# The broad 777/666 above should cover wp-content and its subdirectories.
# The specific loop for wp-content subdirs from previous versions is now superseded by the global change.
echo "ONF-WP: Development-friendly permissions applied."

# --- User Guidance for Persistent Permission Issues ---
# This message remains critical as host OS permissions are the ultimate arbiter for bind mounts.
echo ""
echo "#####################################################################################"
echo "ONF-WP: WordPress setup preparation complete (v${ONF_WP_VERSION_ENV})."
echo "PHP-FPM will now start as the 'wodby' user."
echo ""
echo "IF YOU STILL ENCOUNTER PERMISSION ERRORS with WordPress (e.g., cannot upload files, install plugins, or core updates fail):"
echo "It means the 'wodby' user (running PHP) inside the container still doesn't have sufficient"
echo "write access to your local './wordpress' directory (mounted as ${WP_ROOT})."
echo "This is common with Docker Desktop on Windows/macOS due to how host file permissions are mapped and can override container settings."
echo ""
echo "To resolve this, you MUST adjust permissions on your HOST machine:"
echo "  1. Stop this ONF-WP instance: docker-compose down"
echo "  2. Open a terminal on your HOST computer."
echo "  3. Navigate to your ONF-WP project directory (e.g., 'cd your-project-name')."
echo "  4. Execute commands based on your HOST OS:"
echo "     - For Linux:"
echo "       sudo chown -R \$(id -u):\$(id -g) wordpress/"
echo "       sudo find ./wordpress -type d -exec chmod 775 {} \; "
echo "       sudo find ./wordpress -type f -exec chmod 664 {} \; "
echo "       (If the 'wodby' user's ID in the container is 1000, you might use: sudo chown -R 1000:1000 wordpress/)"
echo "     - For macOS / Windows (with Docker Desktop):"
echo "       Ensure Docker Desktop's File Sharing settings allow access to your project path."
echo "       You may also need to adjust permissions on the './wordpress' folder itself using"
echo "       Finder (macOS) or File Explorer (Windows) to ensure your host user (and implicitly Docker)"
echo "       has full read/write access. Often, granting 'Everyone' or your specific user"
echo "       'Full Control' on the './wordpress' folder on the host is necessary for Docker bind mounts to be writable by the container user."
echo "  5. Restart ONF-WP: docker-compose up -d --build --force-recreate"
echo "Verifying host permissions is key for a smooth experience with bind mounts."
echo "#####################################################################################"
echo ""

# --- Execute PHP-FPM ---
echo "ONF-WP: Starting PHP-FPM as user 'wodby' via Wodby's entrypoint..."
exec /usr/local/bin/docker-php-entrypoint php-fpm -F