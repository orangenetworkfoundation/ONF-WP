# ONF-WP: Your ⚡ Lightning-Fast, 🔒 Secure, Local WordPress Playground! (v1.0.2)

<!-- Badges -->
<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.2-blue.svg" alt="Version 1.0.2">
  <a href="LICENSE.md"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License: MIT"></a>
  <img src="https://img.shields.io/badge/Powered%20by-Docker-blue.svg?logo=docker" alt="Powered by Docker">
  <img src="https://img.shields.io/badge/WordPress-Latest%20Stable-brightgreen.svg?logo=wordpress" alt="WordPress Latest Stable">
  <img src="https://img.shields.io/badge/Project%20Status-Active-brightgreen.svg" alt="Project Status: Active">
  <a href="https://github.com/orangenetworkfoundation"><img src="https://img.shields.io/badge/Org-Orange%20Network%20Foundation-orange.svg" alt="Orange Network Foundation"></a>
  <img src="https://img.shields.io/badge/Integrates%20with-Cloudflare-orange.svg?logo=cloudflare" alt="Integrates with Cloudflare">
</p>

<p align="center">
  <em>Develop WordPress sites locally with a modern, fast, secure, and reliable environment.</em>
</p>

---

## 💡 ONF-WP vs. Traditional Hosting: Key Advantages at a Glance

For those accustomed to cPanel, Plesk, shared hosting, or even managed WordPress VPS solutions, ONF-WP (especially when paired with Cloudflare Tunnels for optional public access) offers a distinct set of advantages:

| Feature/Aspect        | Typical Shared Hosting      | Typical WordPress VPS (e.g., Lightsail, DigitalOcean, basic cPanel VPS) | ONF-WP (Local + Optional Cloudflare Tunnel) |
|-----------------------|-----------------------------|--------------------------------------------------------------------|---------------------------------------------|
| **Primary Cost**      | Monthly fee ($5-$20+)       | Monthly fee ($10-$50+)                                             | **Free** (uses your local hardware/internet) + Optional Free Cloudflare tier |
| **Control over Stack**| Limited                     | Moderate to Full (depends on management)                           | **Full Root Control** (via Docker)            |
| **Performance (Dev)** | Remote, often slower        | Remote, can be slower due to latency                             | **Local, typically very fast**                |
| **HTTPS Setup**       | Varies, can be complex/paid | Usually included, sometimes extra                                  | **Automatic Local HTTPS** (Traefik) + Free Public HTTPS (Cloudflare) |
| **Resource Limits**   | Strict, shared resources    | Defined by VPS plan (CPU, RAM, Storage)                            | Limited by your local machine's power       |
| **Multiple Sites**    | Often extra cost/limited    | Possible, but can strain VPS resources / increase cost           | **Many sites on one machine** (Docker isolation) |
| **Vendor Lock-in**    | High                        | Moderate                                                           | **None** (Open Source, standard Docker)       |
| **Learning Curve**    | Low (for basic use)       | Moderate (for server management)                                   | Moderate (initial Docker/CLI familiarity benefits, but ONF-WP simplifies) |
| **Security (Public)** | Managed by host             | User/Host responsibility (can be complex)                          | **Robust via Cloudflare** (DDoS, WAF on paid plans, Free SSL) |

**Key Takeaways:**

*   **Unmatched Cost-Effectiveness for Many Use Cases:** For local development, staging, demos, or even light-traffic public sites (with Cloudflare Tunnel), ONF-WP can drastically reduce or eliminate hosting costs.
*   **Superior Control & Transparency:** You are not bound by the limitations or opaque configurations of a shared or managed hosting environment. Understand and control your full stack.
*   **Blazing Local Development Speed:** Direct local access means faster iteration cycles compared to developing on remote servers.
*   **Empowerment & Skill Building:** Working with Docker and understanding the components is a valuable skill in modern web development.

While traditional hosting has its place (especially for high-traffic, mission-critical sites requiring managed support and SLAs), ONF-WP provides a powerful, cost-effective, and educational alternative for a vast range of WordPress development and hosting needs.

---

## 😩 Common Frustrations with Local WordPress Setups

**Are you a student, developer, or agency spending significant time dealing with local WordPress environment issues instead of building websites?**

Local WordPress development *should* be straightforward. Yet, many encounter recurring challenges:
*   **Complex Configuration:** Managing different PHP versions, web servers, and database setups for various projects.
*   **Slow Performance:** Waiting for pages to load, which can hinder creativity and productivity.
*   **Inconsistent Environments:** Leading to the "works on my machine" problem and deployment surprises.
*   **HTTPS Difficulties:** Simulating a secure production environment locally is often a complex task.
*   **Resource-Heavy Tools:** Some GUI applications consume many system resources or offer more features than typically needed.

These issues can be a drain on time and energy, acting as a barrier to learning and innovation, and making WordPress development feel more cumbersome than it needs to be.

## ✨ Introducing ONF-WP: A Simple, Powerful Solution

**ONF-WP provides a local WordPress setup that is:**
*   **Fast:** Utilizes Docker and optimized configurations.
*   **Secure:** Offers HTTPS out-of-the-box with Traefik, helping to mimic production environments.
*   **Reliable:** Ensures consistent, isolated environments using industry-standard Docker images.
*   **Simple:** Features minimal setup and clear instructions, avoiding unnecessary complexity.
*   **Developer-Oriented:** Includes WP-CLI and a clean project structure. (Xdebug support is planned).

**ONF-WP (Orange Network Foundation - WordPress)** is a Docker-based local development environment designed to address these common issues. It uses the power and flexibility of Docker in a simple `docker-compose up -d` command, enabling users to get a WordPress site running quickly.

ONF-WP aims to provide a modern, robust, and user-friendly local WordPress development experience, as an alternative to traditional local server stacks (MAMP, WAMP, XAMPP) or complex virtual machine setups.

This tool is intended to support creativity and productivity for students learning WordPress, freelance developers, and agencies.

---

### 🤔 What Makes ONF-WP Different & Why Consider It?

While various tools for local WordPress development exist (e.g., Local by Flywheel, DevKinsta, other Docker setups), ONF-WP focuses on addressing common pain points with tangible benefits:

*   **Benefit 1: Closer Production Parity, Locally & Simply (Addresses: HTTPS & Inconsistency Issues)**
    *   **Feature:** Docker-powered with pre-configured Traefik for automatic HTTPS (via self-signed certificates locally) and custom domain mapping (e.g., `my-project.onfwp.test`).
    *   **Why it Matters:** Develop in an environment that more closely mirrors a modern, secure production server. This helps identify HTTPS-related issues early, saving time and improving confidence. It's also extendable for services like [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/) for public access to your local site (useful for client demos). Cloudflare offers a substantial free tier, beneficial for students and developers exploring distributed applications and security.

*   **Benefit 2: Improved Speed & Efficiency (Addresses: Slow Performance & Complicated Tools)**
    *   **Feature:** Optimized Docker images (drawing from Wodby's solid foundation) and a lightweight setup. [WP-CLI](https://wp-cli.org/) is built-in and accessible.
    *   **Why it Matters:** Experience faster load times and a more responsive WordPress admin. A leaner tool means fewer system resources are typically consumed.

*   **Benefit 3: Simplicity & Control for Developers (Addresses: Complex Configuration & Docker's Learning Curve)**
    *   **Feature:** One-command startup (`docker-compose up -d`). Clear, well-documented configuration files (`.env`, `docker-compose.yml`, `wp-config-onf-sample.php`). An intelligent entrypoint script automates `wp-config.php` generation with unique salts.
    *   **Why it Matters:** Get started relatively quickly. ONF-WP aims to make Docker approachable for newcomers while offering a clean, customizable foundation for experienced users. You understand what's happening under the hood, offering a level of transparency and direct configuration often not available in typical managed cPanel/Plesk environments.

*   **Benefit 4: Clean, Isolated, & Reproducible Project Environments (Addresses: "Works on My Machine" & Project Conflicts)**
    *   **Feature:** Each ONF-WP project is self-contained within Docker containers. WordPress files are organized in a dedicated `./wordpress/` subdirectory.
    *   **Why it Matters:** Helps avoid conflicts between different projects or global machine configurations. Manage multiple WordPress sites more easily. Share setups with team members with greater assurance of consistency. `docker-compose down -v` completely removes a site's Docker-managed volumes (like the database), ensuring a clean slate if needed.

*   **Benefit 5: Open Source & Community Focused (Addresses: Vendor Lock-in & Lack of Transparency)**
    *   **Feature:** 100% open-source (MIT Licensed). Developed with transparency and the needs of students and developers as a priority.
    *   **Why it Matters:** Freedom to use, modify, and contribute. No hidden costs or proprietary limitations.

**In essence, ONF-WP strives to be a practical solution: powerful enough for professional tasks, simple enough for beginners, and efficient for various users.**

---

## 🌟 What's New in v1.0.2? (Key Enhancements)

*   **Cleaner Project Root:** WordPress core files are now in `./wordpress/`, making the project root easier to navigate.
*   **Safer Sample Config:** `wp-config-onf-sample.php` is now in the project root, reducing the risk of accidental deletion with volume cleanup and making it more accessible.
*   **Refined `.gitignore`:** More comprehensive rules for a cleaner repository.
*   **Upgraded Documentation:** This `README.md` and the `ONF-vs-competitors.md` file have been significantly updated for clarity and detail.

---

## 🚀 Let's Get Started: Step-by-Step Guide to ONF-WP Setup

These steps aim to be clear and straightforward for setting up your local WordPress site.

### ✅ Prerequisites: Setting the Stage (What You Need Before You Start)

Ensure you have these standard tools for modern web development:

1.  **Docker Desktop (The Core Engine):**
    *   **What it is:** Docker creates isolated, consistent environments. Docker Desktop is a common way to use Docker on Windows or macOS.
    *   **Why you need it:** ONF-WP relies on Docker to manage services (web server, database, PHP) in containers.
    *   **Action:** Download and install from [Docker Desktop official website](https://www.docker.com/products/docker-desktop/).
    *   **Tip:** After installation, ensure Docker Desktop is running (Docker icon in system tray/menu bar).

2.  **Git (For Project Management):**
    *   **What it is:** Git is a widely-used version control system for tracking changes and collaboration.
    *   **Why you need it:** Cloning the ONF-WP repository with Git is recommended for getting all files correctly and for easier updates.
    *   **Action:** If needed, download and install Git from [git-scm.com](https://git-scm.com/).

3.  **A Code Editor (Your Workbench):**
    *   **What it is:** A text editor for code (e.g., VS Code, Sublime Text, PhpStorm).
    *   **Why you need it:** To edit configuration files (like `.env`) and your WordPress theme/plugin code.
    *   **Recommendation:** [Visual Studio Code (VS Code)](https://code.visualstudio.com/) is a free, popular choice with good Docker integration.

4.  **Web Browser (To View Your Site):**
    *   **What it is:** Chrome, Firefox, Edge, Safari, etc.
    *   **Why you need it:** To view your WordPress site.

5.  **Cloudflare Account (Highly Recommended for Public Access & Enhanced Features - Free Tier is Sufficient):**
    *   **What it is:** [Cloudflare](https://www.cloudflare.com/) is a global network that provides security, performance, and reliability services for websites and applications.
    *   **Why it's highly recommended:** While ONF-WP works perfectly for local-only development without Cloudflare, creating a free Cloudflare account unlocks powerful features if you want to securely expose your local site online or manage your domains professionally:
        *   **Advanced DNS Management:** Easily manage your domain's DNS records. You can point your domain's nameservers to Cloudflare to use their robust DNS services.
        *   **Free SSL/TLS Certificates:** Cloudflare provides free, auto-renewing SSL certificates, ensuring your site can be served over HTTPS. You can also enable the "Always Use HTTPS" feature for enhanced security.
        *   **Cloudflare Tunnels:** A core feature that allows you to securely connect your local ONF-WP environment to the Cloudflare edge without opening public inbound ports on your router. `cloudflared` (the tunnel client) is easy to install on Windows, macOS, and Linux, often in about 60 seconds by following dashboard instructions.
        *   **Additional Free Tier Benefits:** Basic DDoS protection, CDN capabilities for static assets (can speed up your site globally), and more.
    *   **Action:** [Sign up for a free Cloudflare account](https://dash.cloudflare.com/sign-up).
    *   **Note:** Using Cloudflare is optional for purely local development but is essential for the secure public access methods described later in this README.

### 🛠️ Step-by-Step Installation & Setup

With prerequisites met, let's set up your ONF-WP environment.

**Step 1: Get the ONF-WP Files**

*   **Option A (Recommended): Clone the Repository using Git command line**
    *   **Why this way?** Ensures correct file structure and simplifies updates via `git pull`.
    *   **Action:** Open your terminal/command prompt, navigate to your desired project directory (e.g., `~/Projects/`), and run:
        ```bash
        git clone https://github.com/orangenetworkfoundation/ONF-WP.git your-project-name
        cd your-project-name
        ```
        (Replace `your-project-name` with your folder name, e.g., `my-site`)

*   **Option B: Clone the Repository using GitHub Desktop (GUI alternative)**
    *   **Why this way?** Provides a graphical interface for cloning and managing the repository, which some users find easier than the command line.
    *   **Action:**
        1.  Install [GitHub Desktop](https://desktop.github.com/) if you haven't already.
        2.  Open GitHub Desktop.
        3.  Go to `File` > `Clone Repository...`.
        4.  Select the `URL` tab and paste `https://github.com/orangenetworkfoundation/ONF-WP.git`.
        5.  Choose a local path where you want to save the project and give it a local name (e.g., `my-site`).
        6.  Click `Clone`.
        7.  Once cloned, navigate into this directory in your terminal or using your file explorer to proceed with the next steps.

*   **Option C: Manual Download (If you prefer not to use Git or GitHub Desktop initially)**
    *   **Action:**
        1.  Go to the [ONF-WP GitHub repository](https://github.com/orangenetworkfoundation/ONF-WP).
        2.  Click "Code" -> "Download ZIP".
        3.  Extract the ZIP to your project location and rename the folder.
        4.  Navigate into this directory in your terminal.

**Step 2: Configure Your Environment (The `.env` File)**

Customize ONF-WP for your project using the `.env` file for environment variables.

*   **Action:**
    1.  In your project root, find `.env.example`. **Copy or rename this file to `.env`**.
        *   Terminal: `cp .env.example .env` (macOS/Linux) or `copy .env.example .env` (Windows).
    2.  Open the new `.env` file in your code editor.
    3.  **Crucial! Update `COMPOSE_PROJECT_NAME`:**
        *   **Why?** This **must be unique** for each ONF-WP instance on your machine to prevent conflicts (this is how Docker keeps different ONF-WP sites separate and identifiable on your computer). Use lowercase letters, numbers, and no spaces (e.g., `myproject`, `client1`).
        *   **Example:** `COMPOSE_PROJECT_NAME=myfirstsite`
    4.  **Review/Update `PROJECT_DOMAIN` (Your Local Site Address):**
        *   **Why?** Sets the local domain for your WordPress site (e.g., `myfirstsite.onfwp.test`).
        *   **Recommendation:** Stick to `.onfwp.test`, `.localhost`, or `.test` suffixes to avoid conflicts with real domains. Ensure it's unique if running multiple sites.
        *   **Example:** `PROJECT_DOMAIN=myfirstsite.onfwp.test`
    5.  **Configure `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL` (Your WordPress Admin):**
        *   **Why?** Credentials for the WordPress administrator account created on first setup.
        *   **CRITICAL:** **Use a STRONG, UNIQUE password for `WP_ADMIN_PASSWORD`.**
        *   **Example:**
            ```env
            WP_ADMIN_USER=adminuser
            WP_ADMIN_PASSWORD=Str0ng!P@sswOrd$
            WP_ADMIN_EMAIL=user@example.com
            ```
    6.  **Review `TRAEFIK_HTTP_PORT`, `TRAEFIK_HTTPS_PORT`, `TRAEFIK_WEBUI_PORT` (Advanced):**
        *   **Why?** Ports Traefik uses on your host. Defaults: `80` (HTTP), `443` (HTTPS), `8080` (Traefik Dashboard).
        *   **When to change?** Only if these ports are in use by another application. If changed, include the new port in your browser URL (e.g., `http://myfirstsite.onfwp.test:8000`).
    7.  **Save the `.env` file.**

**Step 3: Start ONF-WP with Docker Compose**

Docker Compose will read your configuration and start the services.

*   **Action:** In your terminal (from project root), run:
    ```bash
    docker-compose up -d
    ```
    *   `docker-compose up`: Starts services.
    *   `-d`: Detached mode (runs in background).

*   **What to Expect (First Time):**
    *   Docker downloads images (Nginx, MariaDB, WordPress, Traefik). This may take time.
    *   Subsequent starts are much faster (cached images).
    *   Output indicates container creation and startup.

*   **Line Endings Note for Windows Users (CRITICAL for `onf-wp-entrypoint.sh`):**
    *   The `onf-wp-entrypoint.sh` script needs LF (Unix-style) line endings, not CRLF (Windows-style), to run correctly inside the Linux container.
    *   **How to ensure LF:**
        *   **Git Configuration:** Correct Git configuration (`git config --global core.autocrlf input` on Windows) often handles this during cloning.
        *   **VS Code:** Open `onf-wp-entrypoint.sh`. Check/change line endings in the status bar (bottom-right).
        *   **Other Editors:** Most code editors allow changing line endings.
    *   **Incorrect line endings are a common cause of entrypoint script issues on Windows.**

**Step 4: Access Your Site & Traefik Dashboard**

Once `docker-compose up -d` completes:

*   **Access Your WordPress Site:**
    *   Open your browser to your `PROJECT_DOMAIN` (e.g., `https://myfirstsite.onfwp.test`).
    *   **HTTPS Note:** Expect a browser warning ("untrusted certificate"/"connection not private"). This is **NORMAL** due to the self-signed SSL certificate for local HTTPS. Click "Advanced" and "Proceed..." or equivalent. This is safe for local development.
    *   You should see the WordPress installation screen or your site (our script handles initial setup using `.env` admin credentials).

*   **Access WordPress Admin:**
    *   Go to `https://<your-PROJECT_DOMAIN>/wp-admin/`.
    *   Log in with `WP_ADMIN_USER` and `WP_ADMIN_PASSWORD` from `.env`.

*   **Access Traefik Dashboard (Optional):**
    *   Shows Traefik status and managed services.
    *   Go to `http://localhost:<TRAEFIK_WEBUI_PORT>` (e.g., `http://localhost:8080`).

🎉 **Setup Complete! You have a functional, HTTPS-enabled, local WordPress site with ONF-WP.** 🎉

### ☀️ Daily Usage: Interacting With Your ONF-WP Environment

Common commands:

*   **Stop ONF-WP:**
    *   `docker-compose stop`
    *   **What it does:** Stops containers; data remains. Use when done working to free resources.

*   **Start ONF-WP (After Stopping):**
    *   `docker-compose start`
    *   **What it does:** Restarts stopped containers.

*   **Stop and Remove Containers (Preserves Data Volumes):**
    *   `docker-compose down`
    *   **What it does:** Stops and removes containers. Data in Docker volumes (database) or bind mounts (WordPress files) is **preserved**.
    *   **When to use:** Use to clean up container resources if you intend to restart later with the same data.

*   **Completely Stop and Remove Everything (Use With Caution!):**
    *   `docker-compose down -v`
    *   **What it does:** Stops/removes containers AND **deletes Docker volumes (database!)**. Local files (`./wordpress/`, `.env`) remain.
    *   ⚠️ **DANGER:** Only use to completely reset a site with a fresh database. **No undo for deleted volumes.**

*   **View Logs (Troubleshooting):**
    *   Follow logs: `docker-compose logs -f`
    *   Specific service: `docker-compose logs -f php` (or `nginx`, `db`, `traefik`, `wpcli`)
    *   **What it does:** Shows service output. Press `Ctrl+C` to stop.

*   **Access WP-CLI (WordPress Command Line):**
    *   Format: `docker-compose exec wpcli wp <your-wp-cli-command>`
    *   **What it does:** Allows you to run any WP-CLI command directly against your WordPress site.
    *   **Examples:**
        *   `docker-compose exec wpcli wp plugin list`
        *   `docker-compose exec wpcli wp plugin install jetpack --activate`
        *   `docker-compose exec wpcli wp core update`
        *   `docker-compose exec wpcli wp core update-db`
    *   **Benefit:** Powerful for managing WordPress.

### 🗂️ Developing Your Theme/Plugins: Code Location

*   WordPress installation (core, themes, plugins) is in `./wordpress/`.
*   **Themes:** `./wordpress/wp-content/themes/`
*   **Plugins:** `./wordpress/wp-content/plugins/`
*   Changes to files in `./wordpress/` on your host machine are **immediately reflected** in the site (due to bind mounting). No container restart needed for PHP/CSS/JS changes during theme/plugin development.

### 🔩 Advanced Usage & Customization

*   **Accessing the Database Directly:**
    *   MariaDB port isn't exposed by default.
    *   **To expose (for GUI tool like TablePlus, DBeaver):**
        1.  Open `docker-compose.yml`.
        2.  Find the `db` service.
        3.  Uncomment or add the `ports` section:
            ```yaml
            services:
              db:
                # ... other db config ...
                ports:
                  - "${MARIADB_PORT_FORWARD:-3306}:3306" # Exposes DB port 3306
            ```
        4.  Optional: Add `MARIADB_PORT_FORWARD=your_host_port` to `.env` for a host port other than `3306`.
        5.  Run `docker-compose up -d` to apply.
        6.  **Connection Details:** Host: `127.0.0.1`; Port: exposed host port (e.g., `3306`); User/Password/Database: `wordpress` (from `docker-compose.yml` `db` service environment).

*   **Modifying PHP/Nginx Configurations:**
    *   Based on Wodby Docker images.
    *   **For advanced overrides:** May involve mounting custom `.ini` (PHP) or `.conf` (Nginx) files via `docker-compose.yml`. Refer to the [Wodby Docker4WordPress documentation](https://wodby.com/docs/stacks/wordpress/containers/) for image-specifics.

*   **Xdebug (Planned Feature):**
    *   Easy Xdebug integration for PHP step-debugging is planned.

*   **Using with Cloudflare Tunnel (Secure Public Access to Local Site for Free):**
    *   **The Technology:** [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/) (part of [Cloudflare Zero Trust](https://www.cloudflare.com/learning/access-management/what-is-cloudflare-zero-trust/)) allows secure exposure of your local ONF-WP site to the internet via your domain or a temporary Cloudflare one. Useful for client demos, webhooks, or light-traffic personal sites without traditional hosting fees.
    *   **Key Advantages:**
        *   **Secure Connection:** No need to open router ports. `cloudflared` creates a secure, outbound-only connection.
        *   **Free SSL/TLS:** Cloudflare provides free, auto-renewing SSL certificates.
        *   **Enhanced Security:** Enforce "Always Use HTTPS" and leverage other Cloudflare free tier security (e.g., basic DDoS protection).
        *   **Significant Cost Savings:** Cheaper than traditional hosting ($10/month+). Main costs: internet and local machine.
        *   **High-Quality Hosting Potential:** Manage your environment with ONF-WP, leverage Cloudflare's network for delivery/security.
    *   **General Steps (Refer to official Cloudflare docs for current details):**
        1.  **Ensure your Cloudflare Account is Ready:** If you haven't already as per the prerequisites, [sign up for a free Cloudflare account](https://dash.cloudflare.com/sign-up). If using your own domain, ensure it has been [added to your Cloudflare account](https://developers.cloudflare.com/fundamentals/get-started/setup/add-site/) and its nameservers are pointing to Cloudflare.
        2.  **Install `cloudflared`:** On your machine. See [Install `cloudflared`](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/).
        3.  **Login `cloudflared`:** `cloudflared login`.
        4.  **Create Tunnel:** `cloudflared tunnel create my-tunnel-name`. Note ID and credentials file path.
        5.  **Configure DNS:** CNAME record in Cloudflare DNS (e.g., `mysite.yourdomain.com` to `<YOUR_TUNNEL_UUID>.cfargotunnel.com`).
        6.  **Route Traffic:** `cloudflared tunnel route dns my-tunnel-name mysite.yourdomain.com`.
        7.  **Run Tunnel:**
            ```bash
            cloudflared tunnel run --url https://localhost:${TRAEFIK_HTTPS_PORT:-443} my-tunnel-name
            ```
            (Ensure `TRAEFIK_HTTPS_PORT` in `.env` is correct. Replace `my-tunnel-name`.)
        8.  **Configure Traefik for Public Domain:** In ONF-WP `.env`, set `PROJECT_DOMAIN` to your public domain (e.g., `mysite.yourdomain.com`). Restart ONF-WP (`docker-compose down && docker-compose up -d`).
        9.  **Enable "Always Use HTTPS" (Cloudflare):** Dashboard -> "SSL/TLS" -> "Edge Certificates" -> toggle on.

### 🤕 Troubleshooting Common Issues

*   **"Port is already allocated" / "Address already in use":**
    *   **Cause:** Another app/Docker project using a port ONF-WP needs (80, 443, 8080, 3306 if exposed).
    *   **Solution:** Stop other app OR change conflicting port in ONF-WP `.env` (e.g., `TRAEFIK_HTTP_PORT=8000`), run `docker-compose up -d`. Use new port in browser.

*   **Site Not Loading / Errors After `docker-compose up -d`:**
    *   **Solution:** Check logs: `docker-compose logs -f` or `docker-compose logs -f php`.
    *   **Common causes:** Incorrect line endings in `onf-wp-entrypoint.sh` (Windows CRLF); Typos in `.env`; `wp-config.php` generation problems; DB connection issues.

*   **Browser HTTPS Warning ("Connection not private"):**
    *   **Cause:** Expected (self-signed SSL).
    *   **Solution:** Click "Advanced" and "Proceed...". Safe for local use.

*   **Permission Issues with `./wordpress/` directory (Less Common on Mac/Win):**
    *   **Cause (Linux):** Container user (e.g., `www-data`) might lack write access to bind-mounted `./wordpress/`.
    *   **Solution (Linux):** Adjust host permissions: `sudo chown -R $(id -u):$(id -g) wordpress/` or ensure dir is writable by PHP container user ID. **Avoid `chmod 777`.**

*   **"ERROR: for ... Pool overlaps with other one on this address space":**
    *   **Cause:** Docker network conflict (another Docker Compose project using same default subnet).
    *   **Solution:** Explicitly define a unique network in `docker-compose.yml` (advanced). See Docker Compose networking docs.

---

## 🤔 Understanding How ONF-WP Works (A Brief Technical Overview)

ONF-WP components work together:

1.  **`docker-compose.yml`:** Defines services (PHP, Nginx, [MariaDB](https://mariadb.org/), [Traefik](https://traefik.io/traefik/), [WP-CLI](https://wp-cli.org/)), images, environment variables, networks, volume mounts. The environment blueprint.
2.  **`.env` File:** Project-specific configuration for `docker-compose.yml`. **Key for running multiple ONF-WP projects: unique `COMPOSE_PROJECT_NAME` and `PROJECT_DOMAIN` for each.**
3.  **Traefik (Reverse Proxy):** Entry point for web traffic. Reads [Docker](https://www.docker.com/) labels to route to WordPress. Generates self-signed SSL. Web UI (default: `http://localhost:8080`).
4.  **PHP Service (`php`):** Runs WordPress (Wodby PHP-FPM image). Uses `onf-wp-entrypoint.sh`. Mounts `./wordpress:/var/www/html/wordpress:cached`, `./onf-wp-entrypoint.sh`, `./wp-config-onf-sample.php`.
5.  **`onf-wp-entrypoint.sh` (Setup Script):** Runs on `php` container start. Checks for WP install. If none, downloads core, sets up `wp-config.php` (from sample and `.env`), injects unique security keys and salts (randomized strings that improve security for login sessions and cookies), optionally runs WP-CLI install. Ensures permissions. Executes original Wodby image command.
6.  **Nginx Service (`nginx`):** Wodby Nginx image (serves PHP via PHP-FPM). Mounts `./wordpress:/var/www/html/wordpress:cached` for static assets. `NGINX_SERVER_ROOT` is `/var/www/html/wordpress`.
7.  **MariaDB Service (`mariadb`):** Database server. Data stored in named Docker volume (`db_data_${COMPOSE_PROJECT_NAME}`), persists `docker-compose down` (unless `-v` used).
8.  **WP-CLI Service (`wpcli`):**
    *   A lightweight container with WP-CLI installed, configured to connect to your WordPress installation running in the `php` service and its `mariadb` database.

---

## 💰 How to Save Money with ONF-WP

ONF-WP can help reduce costs significantly, especially when contrasted with traditional web hosting approaches:

1.  **Minimize Development/Staging Hosting Costs:**
    *   Traditional hosting for multiple dev/staging sites can be costly (typically $5-$20+ per site per month for basic shared hosting, and more for VPS-like environments).
    *   With ONF-WP, your local machine is the server. Host multiple sites locally at no extra per-site fee, limited only by your computer's resources.

2.  **Use Free Tiers for Public Access (via Cloudflare Tunnel) - A True Game Changer:**
    *   Expose local sites securely for free (see "Using with Cloudflare Tunnel").
    *   Ideal for: Student projects, client demos, personal blogs/portfolios, and early-stage startups.
    *   **Direct Cost Comparison:** This approach directly bypasses the typical monthly fees of hosting companies. For instance, a basic VPS suitable for a single WordPress site (like those from Amazon Lightsail, DigitalOcean, HostGator, Bluehost, or Hostinger) can easily cost $10-$50+ per month. With ONF-WP and Cloudflare, your primary recurring operational costs for similar or even superior control and security can be reduced to just your existing internet and electricity.
    *   Offers a high-quality setup with Cloudflare's security/CDN for minimal outlay.

3.  **No Core Software Licensing Fees:**
    *   ONF-WP and its components (Docker, WordPress, Nginx, MariaDB, Traefik, PHP) are open source.

4.  **Efficient Use of Existing Hardware:**
    *   Docker's efficiency allows running multiple isolated WordPress sites on modest hardware.

5.  **Reduced Need for Specialized Hosting Early On:**
    *   ONF-WP + Cloudflare Tunnel can defer expensive hosting plans until a project truly needs that scale.

This approach empowers users to build and share WordPress projects with reduced financial burden.

---

## 🏡 Building a Sustainable Home-Based Cloud Business with ONF-WP

ONF-WP, your hardware, and tools like Cloudflare Tunnel can enable a small-scale "home cloud" business or cost-effective micro-hosting/development services. This setup can effectively compete with, and in many ways surpass, standard commercial WordPress VPS hosting plans, especially in terms of cost and direct control.

**The Concept:**
Leverage a capable local machine for multiple client projects or small websites, using ONF-WP for management and Cloudflare Tunnel for secure public access.

**Essential Infrastructure at Home:**
*   **A Reliable Internet Connection:** A stable connection with at least 100Mbps symmetrical speed is recommended for a good user experience. Such plans are increasingly affordable (e.g., around $10-$20 per month in many countries, though this varies significantly by region).
*   **Consistent Power Supply:** Reliable electricity is crucial. If you have access to solar power or other renewable energy sources, you can even offer "clean energy WordPress hosting," a unique selling proposition.

**Example Hardware: Modern Efficiency**
*   An **Apple Mac mini with an M-series chip (e.g., M2, M3, or future M4)**, often starting around $599-$699 USD with 8GB/16GB RAM, is a power-efficient option.
*   **Why it works:**
    *   **Power Efficiency:** Low electricity use (often idling at 5-10 watts and maxing out at 30-60 watts under load for a Mac mini), making 24/7 operation highly economical.
    *   **Sufficient Power:** Modern Apple Silicon (or efficient ARM-based/Intel NUCs) can run multiple Dockerized WordPress sites for low-to-moderate traffic. This setup is far more powerful than typical cheap shared hosting plans and directly competes with entry-level to mid-tier VPS plans that often cost $20-$50+ per month *per site* or per VPS instance.
    *   **Low Initial Investment:** One-time hardware cost vs. ongoing monthly hosting fees.

**How ONF-WP Facilitates This:**
1.  **Efficient Multi-Site Management:** Isolate client projects using unique `COMPOSE_PROJECT_NAME`s.
2.  **Resource Optimization:** Docker containers are lightweight. ONF-WP is lean.
3.  **Secure Public Access via Cloudflare:** Professional and reliable public access with SSL/DDoS protection.
4.  **Full Control & Cost Transparency:** Your primary ongoing costs: electricity, internet. You have full root access (via Docker) and control over your stack, unlike many managed hosting solutions. Charge clients for value, not just hosting resale.

**Considerations for a Home-Based Business:**
*   **Internet:** Stable connection with good upload speed is key.
*   **Backups:** Robust off-site backup strategy for machine and all WordPress data.
*   **Hardware Redundancy/Downtime:** Single point of failure. Suitable where brief downtime is tolerable. Not for mission-critical high-availability without more advanced local redundancy.
*   **Client Expectations:** Transparency about hosting. Focus on value, security (Cloudflare), cost-effectiveness, and the high degree of control/customization possible for their needs (startups, brochure sites, specialized development).
*   **Scalability:** Good for starting and a significant number of small to medium sites. For very high-traffic sites, plan migration to dedicated cloud resources, but ONF-WP can still serve as the development/staging environment.

ONF-WP provides a technical foundation for such ventures, lowering entry barriers for web development and hosting services.

---

## 🙏 Credits and Acknowledgements

ONF-WP stands on the shoulders of giants. We extend our sincere gratitude to:

*   **Divyanshu Singh Chouhan ([@div197](https://github.com/div197)):** For his significant early contributions, conceptualization, and persistent drive in shaping ONF-WP into a robust and user-friendly local development solution.
*   **Wodby (authors of `docker4wordpress`):** For their excellent, well-maintained, and highly optimized Docker images for WordPress, Nginx, MariaDB, and PHP. Their work provides a rock-solid foundation for ONF-WP. While ONF-WP has its own tailored `docker-compose.yml`, entrypoint scripting, and Traefik integration for a specific user experience, the core service images are often sourced from Wodby's public offerings. We highly recommend checking out their [full suite of tools and services](https://wodby.com) for more advanced Docker and hosting needs.
*   **The Docker Team & Community:** For creating and maintaining the revolutionary containerization platform ([Docker](https://www.docker.com/)), that makes ONF-WP possible.
*   **Traefik Labs:** For the powerful and easy-to-use [Traefik Proxy](https://traefik.io/traefik/).
*   **The WordPress Community:** For the incredible open-source CMS ([WordPress.org](https://wordpress.org/)) that powers a significant portion of the web.

---

## 🤝 Contributing to ONF-WP

We welcome contributions! For bug reports, feature suggestions, documentation improvements, or code:

1.  Open an issue on our [GitHub Issues Page](https://github.com/orangenetworkfoundation/ONF-WP/issues).
2.  Fork the repository, make changes, and submit a Pull Request.

Please follow existing styles and provide clear descriptions.

---

## 📜 License

ONF-WP is open-source software licensed under the [MIT License](LICENSE.md).

---

## 🍊 About Orange Network Foundation

Orange Network Foundation is a Not-for-Profit Trust registered in New Delhi, India.

Our focus is on creating and promoting **"Made in India, Made for the World"** open-source projects. We believe in the power of open collaboration to build high-quality, accessible technology.

**Our Mission:** To reduce complexity in technology and make real-world, production-ready solutions accessible to the mass public – including students, developers, small businesses, and lifelong learners. We aim to empower individuals and communities through practical, reliable, and open-source software.

ONF-WP is a testament to this mission, designed to simplify a crucial part of the web development workflow.

Find out more about our initiatives: [Orange Network Foundation Official Website](https://orangenetwork.foundation).

---

<p align="center">
  Happy WordPressing with ONF-WP! 🚀
</p>
