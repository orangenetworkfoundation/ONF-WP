#!/bin/sh
set -e # Exit immediately if a command exits with a non-zero status.

WP_CONFIG_PATH="/var/www/html/wp-config.php"
WP_CONFIG_SAMPLE_PATH="/var/www/html/wp-config-onf-sample.php"

# Only run setup if wp-config.php doesn't exist and the sample does
if [ ! -f "$WP_CONFIG_PATH" ] && [ -f "$WP_CONFIG_SAMPLE_PATH" ]; then
  echo "wp-config.php not found. Configuring from sample..."

  # Copy the sample file to wp-config.php
  cp "$WP_CONFIG_SAMPLE_PATH" "$WP_CONFIG_PATH"
  echo "Copied $WP_CONFIG_SAMPLE_PATH to $WP_CONFIG_PATH"

  # Fetch new salts from WordPress.org API
  echo "Fetching new salts..."
  # Added timeout and retry mechanism for curl
  SALTS=$(curl -s --connect-timeout 5 --retry 3 --retry-delay 2 https://api.wordpress.org/secret-key/1.1/salt/)

  if [ -z "$SALTS" ]; then
    echo "Error: Could not fetch salts from WordPress.org API after retries." >&2
    echo "Please ensure the container has internet access." >&2
    echo "Continuing without replacing salts - using placeholders (INSECURE)." >&2
  else
    echo "Fetched salts successfully."
    # Use awk to replace the placeholder block with the fetched salts
    # This is safer than sed for multi-line replacement with special characters
    awk -v salts="$SALTS" '
      BEGIN { printing = 1 }
      /define\(\'AUTH_KEY\',/ { # Match start of salts block more reliably
        if (printing) {
          print salts
          printing = 0
        }
      }
      /\/\*\*#@-\*\// { # Match end of salts block
        printing = 1
        next # Skip the end comment line itself
      }
      { if (printing) print }
    ' "$WP_CONFIG_PATH" > "$WP_CONFIG_PATH.tmp" && mv "$WP_CONFIG_PATH.tmp" "$WP_CONFIG_PATH"

    if [ $? -eq 0 ]; then
        echo "Replaced salt placeholders in $WP_CONFIG_PATH."
    else
        echo "Error: Failed to replace salts in $WP_CONFIG_PATH." >&2
        # Consider removing the potentially broken wp-config.php? It might be better to leave it with placeholders.
    fi
  fi

  # Set permissions appropriate for wodby user/group which runs php-fpm
  # This might be necessary as the file is created by root initially in the script
  chown wodby:wodby "$WP_CONFIG_PATH"
  chmod 640 "$WP_CONFIG_PATH" # Restrict permissions slightly

  echo "wp-config.php configured."

elif [ ! -f "$WP_CONFIG_PATH" ] && [ ! -f "$WP_CONFIG_SAMPLE_PATH" ]; then
    echo "Warning: Neither wp-config.php nor wp-config-onf-sample.php found." >&2
    echo "Proceeding with default image setup (may generate its own wp-config)." >&2
elif [ -f "$WP_CONFIG_PATH" ]; then
    echo "wp-config.php already exists. Skipping configuration."
fi

# --- Execute Original Command ---
# The wodby/wordpress image uses an init system (see docker-compose 'init: true')
# and its entrypoint likely manages PHP-FPM and other services.
# We should execute the command passed to the container, or the image's default CMD.
# Using `exec "$@"` allows us to pass the original command intended for the container.
echo "Executing command: $@"
exec "$@" 