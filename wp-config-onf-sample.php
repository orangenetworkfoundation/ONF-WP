<?php
/**
 * ONF WP Configuration Sample - HTTPS Enabled & Environment Variable Aware
 * v1.0.4: Added CONCATENATE_SCRIPTS definition.
 */

// ** Database settings - Pulled from environment variables set in docker-compose.yml ** //
define( 'DB_NAME', getenv('COMPOSE_PROJECT_NAME') ?: 'onf_wp_db' );
define( 'DB_USER', getenv('COMPOSE_PROJECT_NAME') ?: 'onf_wp_user' );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'localdevpassword' );
define( 'DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 * This block is replaced by the entrypoint script with fresh salts from WordPress.org.
 */
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');
/**#@-*/

/**
 * WordPress database table prefix.
 */
$raw_table_prefix = getenv('WORDPRESS_TABLE_PREFIX');
if ($raw_table_prefix) {
    $sanitized_prefix = str_replace('-', '_', $raw_table_prefix);
    $sanitized_prefix = preg_replace('/[^a-zA-Z0-9_]/', '', $sanitized_prefix);
    if (substr($sanitized_prefix, -1) !== '_') {
        $sanitized_prefix .= '_';
    }
    $table_prefix = $sanitized_prefix;
} else {
    $table_prefix = 'wp_';
}

/**
 * For developers: WordPress debugging mode.
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */

// --- ONF WP HTTPS Configuration ---
$project_domain_env = getenv('PROJECT_DOMAIN');
$site_protocol = 'https';
$site_host = $project_domain_env;

if ($project_domain_env) {
    define('WP_HOME', $site_protocol . '://' . $site_host );
    define('WP_SITEURL', $site_protocol . '://' . $site_host );
} else {
    error_log('Warning: PROJECT_DOMAIN environment variable not set in wp-config.php');
    define('WP_HOME', 'https://your-project.localhost');
    define('WP_SITEURL', 'https://your-project.localhost');
}

if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos(strtolower($_SERVER['HTTP_X_FORWARDED_PROTO']), 'https') !== false) {
    $_SERVER['HTTPS'] = 'on';
}
elseif (defined('WP_SITEURL') && strpos(WP_SITEURL, 'https://') === 0) {
    $_SERVER['HTTPS'] = 'on';
}
// --- End ONF WP HTTPS Configuration ---

/** Docker: Allow direct file system operations for updates/installs */
define('FS_METHOD', 'direct');

/** Concatenate admin scripts for a minor performance improvement. */
if ( ! defined( 'SCRIPT_DEBUG' ) || ( defined( 'SCRIPT_DEBUG' ) && false === SCRIPT_DEBUG ) ) {
    define( 'CONCATENATE_SCRIPTS', true );
}


/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';

?>