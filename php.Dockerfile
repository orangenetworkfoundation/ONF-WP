# php.Dockerfile for ONF-WP v1.0.4 PHP Service
# Builds upon Wodby WordPress image, integrates custom setup, and sets PHP defaults.

ARG WODBY_WORDPRESS_TAG=latest
FROM wodby/wordpress:${WODBY_WORDPRESS_TAG}

ENV LANG="C.UTF-8"
ENV ONF_WP_VERSION="1.0.4"

# Copy custom entrypoint and wp-config sample.
# CRITICAL: Ensure onf-wp-entrypoint.sh in your Git repository & build context has LF line endings.
COPY onf-wp-entrypoint.sh /usr/local/bin/onf-wp-entrypoint.sh
COPY wp-config-onf-sample.php /tmp/wp-config-onf-sample.php

USER root

# 1. Ensure script has correct line endings (LF) and is executable.
#    Attempt to install dos2unix or use sed as a fallback.
# 2. Create custom PHP INI settings for ONF-WP.
RUN \
    # Install dos2unix if possible (for robust line ending conversion)
    if command -v apt-get > /dev/null; then \
        apt-get update && apt-get install -y dos2unix && apt-get clean; \
    elif command -v apk > /dev/null; then \
        apk add --no-cache dos2unix; \
    else \
        echo "ONF-WP Dockerfile: apt-get or apk not found, cannot install dos2unix." >&2; \
    fi && \
    # Apply line ending conversion and make executable
    if command -v dos2unix > /dev/null; then \
        dos2unix /usr/local/bin/onf-wp-entrypoint.sh; \
    else \
        echo "ONF-WP Dockerfile: dos2unix not found, using sed for line endings on onf-wp-entrypoint.sh." >&2; \
        sed -i 's/\r$//' /usr/local/bin/onf-wp-entrypoint.sh; \
    fi && \
    chmod +x /usr/local/bin/onf-wp-entrypoint.sh && \
    \
    # Create ONF-WP specific PHP settings to override defaults
    # These settings are generally more WordPress development friendly.
    echo "ONF-WP Dockerfile: Applying custom PHP settings..." && \
    { \
        echo "; ONF-WP Custom PHP Settings (v${ONF_WP_VERSION})"; \
        echo "upload_max_filesize = 64M"; \
        echo "post_max_size = 72M"; \
        echo "memory_limit = 256M"; \
        echo "max_execution_time = 300"; \
        echo "max_input_time = 300"; \
        echo "cgi.fix_pathinfo = 0"; \
        echo "date.timezone = UTC"; \
    } > /usr/local/etc/php/conf.d/onf-wp-settings.ini && \
    echo "ONF-WP Dockerfile: Custom PHP settings applied to onf-wp-settings.ini"

# The Wodby entrypoint script (called by our script) will handle
# the final user switch to 'wodby' before exec'ing php-fpm.
# Our onf-wp-entrypoint.sh will run as root, which is intended for initial setup.

ENTRYPOINT ["/usr/local/bin/onf-wp-entrypoint.sh"]
CMD ["/usr/local/bin/docker-php-entrypoint", "php-fpm", "-F"]