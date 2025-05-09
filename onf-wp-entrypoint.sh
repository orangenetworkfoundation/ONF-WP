#!/bin/sh
set -e # Exit immediately if a command exits with a non-zero status.

WP_CONFIG_PATH="/var/www/html/wp-config.php"
WP_CONFIG_SAMPLE_PATH="/var/www/html/wp-config-onf-sample.php"

# Only run setup if wp-config.php doesn't exist and the sample does
if [ ! -f "${WP_CONFIG_PATH}" ] && [ -f "${WP_CONFIG_SAMPLE_PATH}" ]; then
  echo "wp-config.php not found. Configuring from sample..."

  # Copy the sample file to wp-config.php
  cp "${WP_CONFIG_SAMPLE_PATH}" "${WP_CONFIG_PATH}"
  echo "Copied ${WP_CONFIG_SAMPLE_PATH} to ${WP_CONFIG_PATH}"

  # Fetch new salts from WordPress.org API
  echo "Fetching new salts..."
  # Ensure SALTS_OUTPUT is empty if curl fails, to prevent issues with awk
  SALTS_OUTPUT=""
  SALTS_OUTPUT=$(curl -fsS --connect-timeout 5 --retry 3 --retry-delay 2 https://api.wordpress.org/secret-key/1.1/salt/)
  CURL_EXIT_CODE=$?

  if [ ${CURL_EXIT_CODE} -ne 0 ] || [ -z "${SALTS_OUTPUT}" ]; then
    echo "Error: Could not fetch salts from WordPress.org API (curl exit code: ${CURL_EXIT_CODE})." >&2
    echo "Please ensure the container has internet access and the API is reachable." >&2
    echo "Continuing without replacing salts - using placeholders (INSECURE)." >&2
  else
    echo "Fetched salts successfully."
    # Use awk to replace the placeholder block with the fetched salts
    # Ensure the salts variable is properly quoted for awk, especially if it could be multi-line
    # The previous awk script had complex escaping for define('AUTH_KEY', which might be problematic.
    # A simpler approach: use a unique delimiter string that won't appear in salts, and replace that block.
    
    # Create a temporary file with the salts
    echo "${SALTS_OUTPUT}" > /tmp/salts.txt

    # Use awk to read salts from the file and substitute the placeholder block
    # This avoids complex variable expansion issues directly in the awk command line for the salts themselves.
    # The placeholder block in wp-config-onf-sample.php starts with /**#@+ and ends with /**#@-*/
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
    ' "${WP_CONFIG_PATH}" > "${WP_CONFIG_PATH}.tmp"
    
    if [ $? -eq 0 ]; then
      mv "${WP_CONFIG_PATH}.tmp" "${WP_CONFIG_PATH}"
      if [ $? -eq 0 ]; then
        echo "Replaced salt placeholders in ${WP_CONFIG_PATH}."
      else
        echo "Error: Failed to move temporary wp-config back (mv exit code: $?)." >&2
        rm -f "${WP_CONFIG_PATH}.tmp" # Clean up temp file on error
      fi
    else
      echo "Error: awk command failed to process salts (awk exit code: $?)." >&2
      rm -f "${WP_CONFIG_PATH}.tmp" # Clean up temp file on error
    fi
    rm -f /tmp/salts.txt # Clean up salts temp file
  fi

  # Set permissions appropriate for wodby user/group which runs php-fpm
  chown wodby:wodby "${WP_CONFIG_PATH}"
  chmod 640 "${WP_CONFIG_PATH}" # Restrict permissions slightly

  echo "wp-config.php configured."

  # Check if WordPress core files exist, if not, download them
  # Specifically checking for wp-includes/version.php as a reliable indicator.
  if [ ! -f "/var/www/html/wp-includes/version.php" ]; then
    echo "WordPress core files not found in /var/www/html. Attempting to download..."
    
    # Attempt to download as wodby user first, then fallback to root if gosu or wp fails.
    # Using --allow-root is generally needed if wp-cli is run as root.
    # The Wodby image should have gosu and wp-cli available.
    if false && gosu wodby php -d memory_limit=512M /usr/local/bin/wp core download --path="/var/www/html" --locale="en_US" --version="latest"; then # gosu was not found, so disabled for now
      echo "WordPress core downloaded successfully as wodby user."
    elif php -d memory_limit=512M /usr/local/bin/wp core download --path="/var/www/html" --locale="en_US" --version="latest" --allow-root; then
      echo "WordPress core downloaded successfully as root user (using increased memory limit)."
    else
      echo "Error: Failed to download WordPress core using both wodby user and root." >&2
      # Consider exiting if core download is critical and fails, or let Wodby entrypoint handle it.
      # For now, we\'ll log the error and continue, Wodby entrypoint might have its own recovery or error.
    fi
    
    # Attempt to set ownership to wodby:wodby
    echo "Attempting to set ownership to wodby:wodby for /var/www/html..."
    chown -R wodby:wodby /var/www/html || echo "Warning: chown on /var/www/html failed. This might lead to issues if PHP cannot write to necessary directories later (e.g., uploads)."

    # Set permissions:
    # Directories: rwxr-xr-x (755)
    # Files: rw-r--r-- (644)
    # This allows owner (ideally wodby, or root if chown failed) to read/write,
    # and others (including the wodby group if wodby isn\'t owner) to read.
    echo "Setting base permissions for /var/www/html (dirs 755, files 644)..."
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;

    # Secure wp-config.php specifically.
    if [ -f "/var/www/html/wp-config.php" ]; then
        echo "Securing wp-config.php (644)..."
        chmod 644 /var/www/html/wp-config.php
    fi
  else
    # If core files were already found, still ensure permissions are checked/set,
    # as they might have been altered or be from an inconsistent state.
    echo "WordPress core files found. Re-applying ownership and permissions for consistency..."
    chown -R wodby:wodby /var/www/html || echo "Warning: chown on existing /var/www/html failed."
    find /var/www/html -type d -exec chmod 755 {} \;
    find /var/www/html -type f -exec chmod 644 {} \;
    if [ -f "/var/www/html/wp-config.php" ]; then
        chmod 644 /var/www/html/wp-config.php
    fi
  fi

elif [ ! -f "${WP_CONFIG_PATH}" ] && [ ! -f "${WP_CONFIG_SAMPLE_PATH}" ]; then
    echo "Warning: Neither wp-config.php nor wp-config-onf-sample.php found." >&2
    echo "Proceeding with default image setup (may generate its own wp-config)." >&2
elif [ -f "${WP_CONFIG_PATH}" ]; then
    echo "wp-config.php already exists. Skipping configuration."
fi

# --- Execute Original Command ---
# Modified: Instead of chaining to Wodby's full /docker-entrypoint.sh,
# we attempt to directly execute the PHP-FPM process via its specific wrapper,
# as Wodby's main entrypoint seems to complete its WordPress setup tasks
# (like running init scripts from /docker-entrypoint-init.d/)
# but the final exec to start PHP-FPM is what seems to be failing silently or causing a loop.

echo "Attempting to directly start PHP-FPM via Wodby's docker-php-entrypoint..."
# This assumes /usr/local/bin/docker-php-entrypoint is the script that ultimately starts php-fpm
# and that php-fpm -F is the command to run it in foreground.
exec /usr/local/bin/docker-php-entrypoint php-fpm -F 