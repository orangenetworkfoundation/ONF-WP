# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.4] - 2025-05-11

### Added
- **`php.Dockerfile`:** Introduced a dedicated Dockerfile for the `php` service (`php.Dockerfile`). This allows for more robust image customization, including embedding PHP configuration overrides and ensuring script integrity.
- **Embedded PHP Configuration Overrides:** The `php.Dockerfile` now creates a custom `onf-wp-settings.ini` within the image to set more development-friendly PHP defaults:
    - `upload_max_filesize = 64M`
    - `post_max_size = 72M`
    - `memory_limit = 256M`
    - `max_execution_time = 300`
    - `max_input_time = 300`
    - `cgi.fix_pathinfo = 0` (Common setting for Nginx + PHP-FPM)
    - `date.timezone = UTC` (Ensures consistent timezone for PHP date functions)
- **Entrypoint Script Line Ending Robustness:** The `php.Dockerfile` now includes steps to automatically convert `onf-wp-entrypoint.sh` line endings to LF (Unix-style) using `dos2unix` or `sed` during the image build process. This significantly improves cross-platform compatibility, especially for Windows users.

### Changed
- **PHP Service Build Process:** The `php` service in `docker-compose.yml` now uses the `build:` instruction to build its image from the new `php.Dockerfile` instead of directly pulling `wodby/wordpress:latest`. The Wodby image is still used as the `FROM` instruction in the `php.Dockerfile`.
- **`onf-wp-entrypoint.sh` Permissions Strategy:**
    - The script now runs as `root` (as defined by `USER root` before `ENTRYPOINT` in `php.Dockerfile`) to perform initial setup tasks.
    - **Aggressive Permission Setting for Local Development:** Implemented a more comprehensive permission setting strategy to ensure WordPress (running as the `wodby` user via PHP-FPM) has write access to the entire `/var/www/html` directory and its contents from within the container. This includes:
        - Attempting `chown -R wodby:wodby /var/www/html`.
        - Applying `chmod 777` to all directories and `chmod 666` to all files within `/var/www/html`.
        - Specifically ensuring `wp-config.php` is `666` to allow modifications by WordPress/plugins (e.g., for `WP_CACHE` definition by caching plugins).
    - This aims to resolve issues with core file updates, plugin/theme installations, and media uploads directly from the WordPress admin, particularly on Docker Desktop for Windows/macOS where host/container permission mapping can be challenging.
    - Enhanced the user guidance messages printed by the script regarding potential host-side permission adjustments if container-side changes are insufficient.
- **`onf-wp-entrypoint.sh` Directory Creation:**
    - Proactively creates `/var/www/html/wp-content/uploads/fonts` directory during initialization.
- **`wp-config-onf-sample.php`:**
    - Added `define( 'CONCATENATE_SCRIPTS', true );` (conditionally, if `SCRIPT_DEBUG` is not defined or is false) to align with WordPress defaults for admin area script loading.
- **Docker Image Naming:** When building the PHP service, Docker Compose will now typically name the image based on the project directory (e.g., `yourproject-php`) rather than just relying on the Wodby image name directly for the PHP container.

### Fixed
- **WordPress Filesystem Permissions:**
    - **Core File Writability:** WordPress should now report core directories and files as writable in Site Health, allowing for background updates and one-click core updates from the admin panel (provided host OS permissions allow the container's changes to take effect).
    - **`wp-content` Subdirectory Writability:** Resolved issues where `uploads`, `plugins`, `themes`, `upgrade`, and `fonts` subdirectories within `wp-content` might not have been consistently writable by the PHP process. These are now robustly permissioned by the entrypoint script.
    - Addressed the specific Site Health error "Some files are not writable by WordPress" by applying broader write permissions.
- **PHP Resource Limits:** Previously restrictive defaults for `upload_max_filesize`, `post_max_size`, `memory_limit`, and `max_execution_time` have been increased, preventing common errors during theme/plugin uploads or larger operations.
- **Entrypoint Script Execution Failures on Windows:** The "no such file or directory" error when trying to execute `onf-wp-entrypoint.sh` (often due to CRLF line endings) is now mitigated by the line ending conversion step in `php.Dockerfile`.
- **"Unable to find user wodby" Docker Error:** Resolved by removing the explicit `USER wodby` instruction from the `php.Dockerfile`, allowing Wodby's own base image entrypoint scripts to correctly handle user setup and switching before starting PHP-FPM.

### Removed
- **Direct Volume Mounts for `onf-wp-entrypoint.sh` and `wp-config-onf-sample.php`:** These files are now `COPY`'d into the PHP service image via the `php.Dockerfile`, simplifying the `volumes` section in `docker-compose.yml` for the `php` service.

## [1.0.3] - 2025-05-09

### Changed
- **WordPress Installation Workflow:** Shifted to the standard WordPress 5-minute web-based installation process. Users now set up their site title and admin credentials through the browser after initial `docker-compose up`.
- **Traefik HTTPS Handling:** Traefik is now configured to handle full HTTPS termination for the `PROJECT_DOMAIN` using a new `websecure` entrypoint. Includes HTTP to HTTPS redirection.
- **`.env.example` Updates:**
  - Added `COMPOSE_PROJECT_NAME` as a critical variable for unique project identification and resource naming.
  - Added `TRAEFIK_HTTPS_PORT` to configure the host port for Traefik's HTTPS entrypoint.
  - Added `MARIADB_PORT_FORWARD` (commented out by default) for optional direct database access from the host.
  - Removed `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL` variables as they are no longer used for an automated install.
- **`docker-compose.yml` Enhancements:**
  - Added a new dedicated `wpcli` service using the `wordpress:cli` image for direct WP-CLI command execution.
  - Updated Traefik service definition for HTTPS entrypoint and port mapping.
  - Updated Nginx service labels for new HTTPS router and HTTP to HTTPS redirection middleware.
  - Database names and users now directly use `COMPOSE_PROJECT_NAME` for better uniqueness.
  - MariaDB data volume name is now unique (`mariadb_data_${COMPOSE_PROJECT_NAME}`).
  - Minor cleanups and improved comments.
- **`README.md` Overhaul for 1.0.3:**
  - Updated all version references to `1.0.3`.
  - Added a "What's New in v1.0.3" section.
  - Completely rewrote the WordPress installation instructions to guide users through the 5-minute web setup.
  - Clarified WordPress file paths within Docker containers (local `./wordpress` maps to `/var/www/html` in containers).
  - Documented access to the included Adminer service.
  - Updated descriptions of HTTPS functionality to reflect new Traefik setup.
  - Revised WP-CLI usage examples to use the new `wpcli` service.
  - Significantly updated the "Understanding How ONF-WP Works" section to accurately describe all services (including new `wpcli` and `adminer`) and their roles in the v1.0.3 architecture.

### Fixed
- **PHP Container Stability:** Resolved persistent restart loops in the `php` container by:
  - Modifying `onf-wp-entrypoint.sh` to directly execute `docker-php-entrypoint php-fpm -F` after its custom WordPress setup logic, bypassing the full Wodby parent entrypoint which seemed to cause conflicts.
  - Ensuring WordPress core files are downloaded correctly if missing (e.g., after a volume clean) by adding `wp core download` logic with increased PHP memory (`php -d memory_limit=512M`) to `onf-wp-entrypoint.sh`.
  - Refining file permission handling in `onf-wp-entrypoint.sh` (using `chown` with warnings for bind mount limitations and `find ... -exec chmod ...`) to be more robust and allow PHP-FPM (running as root) to operate correctly.
- **Cloudflare Tunnel Compatibility:**
  - Adjusted `wp-config-onf-sample.php` (`WP_HOME`, `WP_SITEURL` to `https://...`) and Traefik labels in `docker-compose.yml` (serving HTTP directly on `web` entrypoint) to correctly handle HTTPS termination at Cloudflare, resolving mixed content issues.
  - Ensured `$_SERVER['HTTPS'] = 'on'` is correctly set in `wp-config.php` by prioritizing `HTTP_X_FORWARDED_PROTO`.
- **WordPress Table Prefix Sanitization:**
  - Updated `wp-config-onf-sample.php` to sanitize the `WORDPRESS_TABLE_PREFIX` environment variable (derived from `COMPOSE_PROJECT_NAME`), replacing hyphens with underscores to prevent WordPress installation errors (e.g., "Error: $table_prefix in wp-config.php can only contain numbers, letters, and underscores.").
- **Crond Service Entrypoint:** Modified `crond` service in `docker-compose.yml` to use a direct entrypoint (`sudo crond -f -L /dev/stdout`) to prevent it from running unnecessary WordPress setup logic from the Wodby image.

### Removed
- Automated WordPress installation via admin credentials in `.env` (superseded by 5-minute web install).
- Logic related to automated admin user creation from `onf-wp-entrypoint.sh` (no longer needed).

## [1.0.2] - 2025-05-09

### Changed
- **Project Structure & WordPress Installation:**
  - WordPress core files are now installed into and served from a `./wordpress/` subdirectory instead of the project root, promoting a cleaner main directory.
  - `wp-config-onf-sample.php` has been moved to the project root (from `./wordpress/`) for easier access and to prevent accidental deletion during volume cleanup. It is now mounted into the PHP container from the root.
- **Configuration File Updates:**
  - `docker-compose.yml`: Updated volume mounts for `php`, `nginx`, and `crond` services to use the `./wordpress/` subdirectory. Added mount for `wp-config-onf-sample.php` from the root. Entrypoint script path for PHP service confirmed.
  - `.gitignore`: Updated to reflect the new paths and ensure `wp-config-onf-sample.php` (in root) is tracked, while its previous location (if any) and the generated `wordpress/wp-config.php` are ignored.
- **Documentation Overhaul:**
  - `README.md`: Received a complete rewrite and massive expansion. It's now structured based on AIDA (Attention, Interest, Desire, Action) principles, offering highly detailed installation, usage, troubleshooting, and "behind the scenes" sections. Information about the Orange Network Foundation is also included, along with improved formatting and badges.
  - `ONF-vs-competitors.md`: Updated to align with the final project structure and features.

## [1.0.1] - 2025-05-08

### Added
- Pre-configured HTTPS support via `wp-config-onf-sample.php` and environment variables.
- Instructions in `README.md` for preparing `wp-config.php` before first run, including secret key generation.
- Specific environment variables in `docker-compose.yml` (`