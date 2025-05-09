# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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