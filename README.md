# ONF WP 1.0.1: Simple, Fast, Local WordPress Development (HTTPS Ready)

Welcome to ONF WP! Run a modern, local WordPress development environment using Docker with minimal setup. Designed by the **Orange Network Foundation (ONF)** for students and developers who want to build with WordPress without cloud costs or complex setups. This version is pre-configured to streamline HTTPS setup, especially when using reverse proxies like the included Traefik or external services like Cloudflare Tunnel.

**Project Repository:** [https://github.com/orangenetworkfoundation/ONF-WP](https://github.com/orangenetworkfoundation/ONF-WP)

**Philosophy:** Simple | Latest | Reliable | Empowering

## Requirements
*   [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Mac/Windows) OR [Docker Engine + Docker Compose](https://docs.docker.com/engine/install/) (Linux).
*   **Crucial: Ensure Docker is installed AND running before proceeding!**
*   A web browser.
*   A text editor.

## Quick Start: Your Local WordPress Site in Minutes

This setup automatically configures WordPress with secure keys and HTTPS support on the first run.

1.  **Create Your Project Folder:** Choose a name for your site (e.g., `my-onf-site`). This name will also be used for your default database name and user.
    ```bash
    mkdir my-onf-site
    cd my-onf-site
    ```

2.  **Download ONF WP Files:**
    *   Clone the repository or download `docker-compose.yml`, `.env.example`, `wp-config-onf-sample.php`, and `onf-wp-entrypoint.sh` into your project folder.
    *   Example clone command (if cloning into an empty `my-onf-site` folder):
        ```bash
        git clone https://github.com/orangenetworkfoundation/ONF-WP.git .
        ```

3.  **Create and Configure Your `.env` File:**
    *   **Copy the Example:** Make a copy of `.env.example` and name it `.env`.
        ```bash
        # On Linux/macOS/Git Bash:
        cp .env.example .env
        # On Windows Command Prompt:
        # copy .env.example .env
        # On Windows PowerShell:
        # Copy-Item .env.example .env
        ```
    *   **Edit `.env`:** Open your newly created `.env` file in a text editor.
    *   **Set `PROJECT_DOMAIN`:** Change the default `PROJECT_DOMAIN` to a unique domain for *this specific project* (e.g., `my-onf-site.localhost` or `my-site.com`).
    *   *(Optional)* Change `TRAEFIK_HTTP_PORT` or `TRAEFIK_WEBUI_PORT` if needed.
    *   Save and close `.env`.

4.  **Launch!**
    *   **Line Endings Note (Important for `onf-wp-entrypoint.sh`):** If you are on Windows, ensure the `onf-wp-entrypoint.sh` file uses LF (Unix-style) line endings, not CRLF (Windows-style). Most text editors (like VS Code) allow you to change this. Incorrect line endings can cause the PHP container to fail to start due to shell script errors. If you cloned the repository using Git on Windows, your Git client should ideally be configured to handle this automatically for `.sh` files (e.g., `core.autocrlf input` or by checking out with LF line endings).
    *   **Clean Start:** Ensure no old `wp-config.php` or WordPress core files exist in this folder if you previously ran ONF-WP here. Only `.env` (that you created), `docker-compose.yml`, `wp-config-onf-sample.php`, and `onf-wp-entrypoint.sh` should be present initially (besides `README`/`LICENSE`, `.env.example`, `.gitignore` and `.git` if cloned).
    *   Make sure you are inside your project folder (`my-onf-site`) in your terminal.
    *   Run:
        ```bash
        docker compose up -d
        ```
    *   *(First time? Docker downloads images - allow a few minutes)*
    *   On the very first run, the `php` container's entrypoint script will automatically generate `wp-config.php` from the sample, fetch unique keys, and copy WordPress core files.

5.  **Access & Install WordPress:**
    *   Open your browser to: `https://<YOUR_PROJECT_DOMAIN>` (using the `PROJECT_DOMAIN` from your `.env` file).
    *   **HTTPS Note:** Accept browser security warnings for `.localhost` domains if they appear (due to self-signed certs).
    *   You should see the WordPress installation screen ("Welcome"). Follow the steps (language, site title, admin user/pass).

6.  **Access Your Database (Adminer):**
    *   Open your browser to: `http://db.<YOUR_PROJECT_DOMAIN>:<TRAEFIK_HTTP_PORT>`.
    *   Login details: Server=`mariadb`, Username/Database=`<Your Project Folder Name>`, Password=`localdevpassword_for_<Your Project Folder Name>`.

## Understanding Your ONF WP Environment
*   **`wp-config-onf-sample.php`:** A template containing database connection logic (using environment variables) and HTTPS proxy settings.
*   **`onf-wp-entrypoint.sh`:** A script run by the PHP container on startup. On the first run, it creates `wp-config.php` from the sample and automatically fetches/inserts unique secret keys.
*   **`wp-config.php`:** Automatically generated on first run with unique keys and correct settings. **Should be added to `.gitignore`.**
*   **Your Files Location:** Your project folder *is* your WordPress root. All core files, themes (`wp-content/themes/`), plugins (`wp-content/plugins/`), and uploads (`wp-content/uploads/`) live directly here on your computer. Edit them locally, see changes instantly.
*   **Database:** MariaDB (latest 11.4.x series) stores your posts, pages, settings, etc. It uses a persistent Docker volume (`mariadb_data`), separate from your project files.
*   **Web Server:** Nginx (latest stable) serves your site, configured for WordPress best practices.
*   **PHP:** Latest stable WordPress running on a recent PHP version via `wodby/wordpress:latest`.
*   **Routing:** Traefik handles incoming requests based on your `PROJECT_DOMAIN` and directs them to Nginx (and Adminer). It can auto-generate self-signed SSL certs for `.localhost` domains.
*   **Database GUI:** Adminer provides a web interface to view and manage your database.
*   **WP-CLI:** WordPress Command Line Interface is included for powerful management tasks.

## Essential Management Commands

Run these from your project folder in the terminal:

*   **View Logs (Essential for Debugging!):**
    *   PHP Errors: `docker compose logs -f php`
    *   Nginx Issues: `docker compose logs -f nginx`
    *   All Services: `docker compose logs -f`
*   **Stop Services (Safely):** `docker compose stop`
*   **Start Stopped Services:** `docker compose start`
*   **Stop & Remove Containers (Keeps DB Data):** `docker compose down`
*   **Stop, Remove Containers & DELETE DATABASE:** `docker compose down -v`
    *   🔴 **WARNING:** This **permanently deletes** your local database for this project! Use only if you want a complete reset and have backups.
*   **Run WP-CLI Commands:**
    ```bash
    # Always include --path=/var/www/html
    docker compose exec php wp plugin list --path=/var/www/html
    docker compose exec php wp user list --path=/var/www/html
    docker compose exec php wp core update --path=/var/www/html
    ```
*   **Database Backup (CRITICAL!):**
    ```bash
    # Creates backup.sql in your project folder
    docker compose exec php wp db export backup.sql --path=/var/www/html
    ```
*   **Database Restore:**
    ```bash
    # Restores from backup.sql in your project folder
    docker compose exec php wp db import backup.sql --path=/var/www/html
    ```
*   **Access Container Shells (Advanced):**
    *   PHP: `docker compose exec php sh`
    *   MariaDB: `docker compose exec mariadb sh`
    *   Nginx: `docker compose exec nginx sh`

## Important Considerations & Best Practices
*   **Script Line Endings (`onf-wp-entrypoint.sh`):** As mentioned in the Quick Start, ensure this script uses LF (Unix) line endings. CRLF (Windows) line endings will cause errors.
*   **`.gitignore`:** Create a `.gitignore` file in your project root and add `wp-config.php` and potentially `.env` to it, to prevent accidentally committing sensitive information.
*   **Secret Keys:** Automatically generated on first run. If you need to invalidate sessions later, you can manually edit `wp-config.php` and generate new keys.
*   **HTTPS Access:** Accessing your site via `https://<YOUR_PROJECT_DOMAIN>` is recommended, especially if using Cloudflare Tunnel. Be aware of potential browser warnings for self-signed certificates on `.localhost` domains.
*   **Regular Backups:** Use `wp db export` frequently! Your files are safe in your project folder, but the database is in a Docker volume.
*   **Security:** Default DB passwords are **NOT secure** and are for **local development ONLY**. Never expose this setup directly to the internet without changing credentials in `docker-compose.yml` (and potentially `wp-config.php` if not using `getenv()`) and implementing robust security.
*   **Updates:**
    *   **WordPress/Themes/Plugins:** Update these through your WordPress Admin dashboard or via `wp-cli`.
    *   **ONF WP Stack (Images):** To update PHP, Nginx, MariaDB etc. to the latest versions supported by ONF WP, run `docker compose pull` occasionally.
*   **Initial File Population:** The *very first* `docker compose up -d` might take slightly longer as the `php` container copies WordPress core files into your project directory (since you provided `wp-config.php` but not the rest).
*   **Email Sending:** Local email sending is **not configured**. WordPress attempts to send email (e.g., password resets) might fail or log PHP warnings. Use an SMTP plugin (like WP Mail SMTP) configured with an external email service if you need reliable email sending during development.
*   **Performance:** On macOS/Windows, performance with very large numbers of files might be slower due to Docker's file sharing. This setup is optimized for typical development workloads.
*   **Nginx Config:** This uses Nginx. Plugins relying on `.htaccess` for rewrite rules will need alternatives or custom Nginx configuration (advanced).
*   **Build Tools (Node.js, etc.):** Not included. Install and run these on your host machine as needed for your development workflow.

## Running Multiple Local Sites

1.  Create a **new folder** for the new site (e.g., `my-second-site`).
2.  Copy `docker-compose.yml`, `.env`, `wp-config-onf-sample.php`, and `onf-wp-entrypoint.sh` into it.
3.  **Edit the new `.env` file:** Set a **unique `PROJECT_DOMAIN`!**
4.  *(Optional)* Adjust `TRAEFIK_HTTP_PORT`/`TRAEFIK_WEBUI_PORT`.
5.  Run `docker compose up -d` in the new folder. `wp-config.php` will be auto-generated with unique keys for this site.

## Advanced: Sharing Online with Cloudflare Tunnel (Free & Secure)

You can securely expose your local site (running via HTTPS thanks to the pre-configured `wp-config.php`) to the internet using Cloudflare's free Zero Trust Tunnels.

1.  **Sign up for Cloudflare:** Get a free account. You might need to add your domain.
2.  **Follow Cloudflare's Tunnel Setup Guide:** Install `cloudflared` locally and authenticate. [Link to Cloudflare Tunnel Docs]
3.  **Configure the Tunnel:**
    *   Set your tunnel's public hostname to match the `PROJECT_DOMAIN` in your `.env` file (e.g., `abcsteps.com`).
    *   Point the tunnel's **Service URL** to `http://localhost:<TRAEFIK_HTTP_PORT>` (e.g., `http://localhost:9000` based on your current `.env`). Cloudflare handles the HTTPS externally; Traefik receives HTTP locally.
    *   **Crucial:** In the tunnel's "Public Hostname" settings, under "Additional application settings" -> "HTTP Settings", set the **HTTP Host Header** to **exactly match** the `PROJECT_DOMAIN` (e.g., `abcsteps.com`). Traefik needs this to route correctly.
4.  **Run `docker compose up -d`** (having already prepared `wp-config.php`).
5.  **Access your site** via the public Cloudflare URL (e.g., `https://abcsteps.com`)! Remember your computer must be on and connected to the internet with `cloudflared` running. The pre-configured `wp-config.php` ensures WordPress handles the proxied HTTPS connection correctly.

## License & Credits

ONF WP 1.0.1 is licensed under the MIT License. See `LICENSE.md`.
Built using excellent Docker images from Wodby ([https://wodby.com](https://wodby.com)), inspired by `docker4wordpress`.
