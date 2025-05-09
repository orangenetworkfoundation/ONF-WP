# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
- Specific environment variables in `docker-compose.yml` (`php` service) to support `getenv()` calls in `wp-config.php` for database credentials and HTTPS settings.
- Added `PROJECT_DOMAIN` to `php` service environment variables in `docker-compose.yml`.
- Added `FS_METHOD=direct` define to `wp-config-onf-sample.php`.

### Changed
- Updated `README.md` setup instructions to use the pre-configured `wp-config.php` method.
- Clarified Adminer login details in `README.md` based on `COMPOSE_PROJECT_NAME`.
- Clarified HTTPS setup and `.localhost` certificate warnings in `README.md`.
- Updated Cloudflare Tunnel instructions in `README.md`.
- Updated multi-site setup instructions in `README.md`.

### Fixed
- Resolved mixed content issues when accessing the site via HTTPS through reverse proxies (like Cloudflare Tunnel + Traefik) by ensuring `wp-config.php` correctly identifies the connection as HTTPS.

## [1.0.0] - 2025-05-07

### Added
- Initial project setup based on Wodby Docker images (`mariadb`, `wordpress`, `nginx`).
- Traefik for reverse proxying and easy domain handling.
- Adminer for database management.
- Crond service for WordPress cron jobs.
- Basic `.env` for project domain and Traefik ports.
- `docker-compose.yml` defining all services and volumes.
- `README.md` with initial setup instructions (auto-generated `wp-config.php`).
- `LICENSE.md` (MIT). 