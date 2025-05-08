# ONF WP 1.0.0: Simple, Fast, Local WordPress Development

Welcome to ONF WP! Run a modern, local WordPress development environment with just two commands. Designed by the **Orange Network Foundation (ONF)** for students and developers who want to build with WordPress without cloud costs or complex setups.

**Philosophy:** Simple | Latest | Reliable | Empowering

## Requirements
*   [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Mac/Windows) OR [Docker Engine + Docker Compose](https://docs.docker.com/engine/install/) (Linux).
*   **Crucial: Ensure Docker is installed AND running before proceeding!**

## Quick Start: Your Local WordPress Site in Minutes

1.  **Create Your Project Folder:** Choose a name for your site.
    ```bash
    mkdir my-onf-site && cd my-onf-site
    ```

2.  **Download ONF WP Files:**
    *   Download `docker-compose.yml` and `.env` from the official ONF WP repository into your project folder (`my-onf-site`).
        *   *(ONF: Provide official download links or `git clone` instructions here)*

3.  **Configure Your Unique Project Domain:**
    *   Open the `.env` file in a text editor.
    *   Find the line: `PROJECT_DOMAIN=onf-wp.localhost`
    *   **IMPORTANT:** Change `onf-wp.localhost` to a **unique domain** for *this specific project*. Using `.localhost` is recommended for local development (e.g., `PROJECT_DOMAIN=my-onf-site.localhost`). Using a real domain requires extra steps (see Advanced section).
    *   *(Optional)* Change `TRAEFIK_HTTP_PORT` (default `8000`) or `TRAEFIK_WEBUI_PORT` (default `8081`) only if those ports are already used on your computer.
    *   Save and close the `.env` file.

4.  **Launch!**
    *   Make sure you are inside your project folder in your terminal.
    *   Run:
        ```bash
        docker compose up -d
        ```
    *   *(First time? Docker downloads software images - allow a few minutes)*
    *   If your project folder was empty, WordPress files (`wp-admin`, `wp-content`...) will automatically appear!

5.  **Access & Install WordPress:**
    *   Open your web browser to: `http://<YOUR_PROJECT_DOMAIN>:<TRAEFIK_HTTP_PORT>`
        *   (e.g., `http://my-onf-site.localhost:8000`)
    *   **Remember:** You **MUST** use the `PROJECT_DOMAIN` you set in the `.env` file. Accessing `http://localhost:8000` will **NOT** work.
    *   You should see the WordPress installation screen ("Welcome"). Follow the steps to choose your language, site title, admin username, password, etc.

6.  **Access Your Database (Adminer):**
    *   Open your web browser to: `http://db.<YOUR_PROJECT_DOMAIN>:<TRAEFIK_HTTP_PORT>`
        *   (e.g., `http://db.my-onf-site.localhost:8000`)
    *   Login details:
        *   System: `MariaDB` (or `MySQL`)
        *   Server: `mariadb`
        *   Username: `<Your Project Folder Name>` (e.g., `my-onf-site`) - This is derived automatically.
        *   Password: `localdevpassword_for_<Username>` (e.g., `localdevpassword_for_my-onf-site`)
        *   Database: `<Your Project Folder Name>` (e.g., `my-onf-site`)

## Understanding Your ONF WP Environment

*   **Your Files Location:** Your project folder *is* your WordPress root. All core files, themes (`wp-content/themes/`), plugins (`wp-content/plugins/`), and uploads (`wp-content/uploads/`) live directly here on your computer. Edit them locally, see changes instantly.
*   **Database:** MariaDB (latest 11.4.x series) stores your posts, pages, settings, etc. It uses a persistent Docker volume (`mariadb_data`), separate from your project files.
*   **Web Server:** Nginx (latest stable) serves your site, configured for WordPress best practices.
*   **PHP:** Latest stable WordPress running on a recent PHP version via `wodby/wordpress:latest`.
*   **Routing:** Traefik handles incoming requests based on your `PROJECT_DOMAIN` and directs them to Nginx.
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

*   **Regular Backups:** Use `wp db export` frequently! Your files are safe in your project folder, but the database is in a Docker volume.
*   **Security:** Default DB passwords are **NOT secure** and are for **local development ONLY**. Never expose this setup directly to the internet without changing credentials and implementing robust security.
*   **Updates:**
    *   **WordPress/Themes/Plugins:** Update these through your WordPress Admin dashboard or via `wp-cli`.
    *   **ONF WP Stack (Images):** To update PHP, Nginx, MariaDB etc. to the latest versions supported by ONF WP, run `docker compose pull` occasionally.
*   **Initial Crond Errors:** On the *very first* `docker compose up`, you might see `crond` log errors like "This does not seem to be a WordPress installation." This is normal while WordPress files are first copied and can be ignored.
*   **Email Sending:** Local email sending is **not configured**. WordPress attempts to send email (e.g., password resets) might fail or log PHP warnings. Use an SMTP plugin (like WP Mail SMTP) configured with an external email service if you need reliable email sending during development.
*   **Performance:** On macOS/Windows, performance with very large numbers of files might be slower due to Docker's file sharing. This setup is optimized for typical development workloads.
*   **Nginx Config:** This uses Nginx. Plugins relying on `.htaccess` for rewrite rules will need alternatives or custom Nginx configuration (advanced).
*   **Build Tools (Node.js, etc.):** Not included. Install and run these on your host machine as needed for your development workflow.

## Running Multiple Local Sites

1.  Create a **new folder** for the new site.
2.  Copy `docker-compose.yml` and `.env` into it.
3.  **Edit the new `.env` file: Set a unique `PROJECT_DOMAIN`!**
4.  *(Optional)* Adjust `TRAEFIK_HTTP_PORT` if running simultaneously.
5.  Run `docker compose up -d` in the new folder. Each project runs isolated.

## Advanced: Sharing Online with Cloudflare Tunnel (Free & Secure)

You can securely expose your local site to the internet for client previews or testing using Cloudflare's free Zero Trust Tunnels.

1.  **Sign up for Cloudflare:** Get a free account. You might need to add your domain (or get one).
2.  **Follow Cloudflare's Tunnel Setup Guide:** Install `cloudflared` locally and authenticate. [Link to Cloudflare Tunnel Docs]
3.  **Configure the Tunnel:**
    *   When creating the tunnel and setting up the public hostname (e.g., `preview.yourdomain.com`), point it to the **Service URL:** `http://localhost:<TRAEFIK_HTTP_PORT>` (e.g., `http://localhost:8000`).
    *   **Crucial:** In the tunnel's "Public Hostname" settings, under "Additional application settings" -> "HTTP Settings", set the **HTTP Host Header** to **exactly match** the `PROJECT_DOMAIN` you have set in your project's `.env` file (e.g., if `.env` has `PROJECT_DOMAIN=preview.yourdomain.com`, set the Host Header to `preview.yourdomain.com`). Traefik needs this to route correctly.
4.  **Set `PROJECT_DOMAIN` Locally:** Ensure the `PROJECT_DOMAIN` in your `.env` file matches the public hostname you configured in Cloudflare (e.g., `PROJECT_DOMAIN=preview.yourdomain.com`).
5.  **Run `docker compose up -d` and access your site via the public Cloudflare URL!** Remember your computer must be on and connected to the internet with `cloudflared` running.

## License & Credits

ONF WP 1.0.0 is licensed under the MIT License. See `LICENSE.md`.
Built using excellent Docker images from Wodby ([https://wodby.com](https://wodby.com)), inspired by `docker4wordpress`.
