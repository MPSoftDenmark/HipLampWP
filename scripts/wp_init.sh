#/bin/bash
# --- Install package dependencies from wp-cli
apt update -qq && apt-get install php5-cli php5-mysql mysql-client -qqy
# -
# --- Download & Install wp-cli deb package
LAST_VERSION_WPCLI=$(curl -s https://github.com/wp-cli/builds/tree/gh-pages/deb  | grep -Eo 'php-wpcli_[0-9\.]*_all.deb' | sort -u | tail -1)
curl -sO "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/deb/${LAST_VERSION_WPCLI}"
dpkg -i ${LAST_VERSION_WPCLI}
rm -v ${LAST_VERSION_WPCLI}
# -
# --- Allow login voe www-data user
sed -i 's|www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin|www-data:x:33:33:www-data:/var/www:/bin/bash|g' /etc/passwd
# -
# --- Install & Configure WP
su www-data -c "
wp --path=/var/www/html/ core config \
--dbname=$(grep 'WP_DBNAM' /scripts/property.cfg | sed 's/^.*=//g') \
--dbuser=$(grep 'WP_DBUSER' /scripts/property.cfg | sed 's/^.*=//g') \
--dbpass=$(grep 'WP_DBPASS' /scripts/property.cfg | sed 's/^.*=//g') \
--dbhost=$(grep 'WP_DBHOST' /scripts/property.cfg | sed 's/^.*=//g') \
--dbprefix=$(grep 'WP_DBPREFIX' /scripts/property.cfg | sed 's/^.*=//g') \
--extra-php <<PHP
define( 'WP_REDIS_HOST', $(grep 'REDIS_IP' /scripts/property.cfg | sed 's/^.*=//g') );
PHP
#
wp --path=/var/www/html/ core install \
--url=$(grep 'WP_URL' /scripts/property.cfg | sed 's/^.*=//g') \
--title=$(grep 'WP_TITLE' /scripts/property.cfg | sed 's/^.*=//g') \
--admin_user=$(grep 'WP_ADMIN_USER' /scripts/property.cfg | sed 's/^.*=//g') \
--admin_password=$(grep 'WP_ADMIN_PASS' /scripts/property.cfg | sed 's/^.*=//g') \
--admin_email=$(grep 'WP_ADMIN_MAIL' /scripts/property.cfg | sed 's/^.*=//g')
#
wp --path=/var/www/html/ plugin install redis-cache --activate
cp -v $(grep 'WP_PLUGIN_REDIS_OBJECT_CACHE' /scripts/property.cfg | sed 's/^.*=//g') /var/www/html/wp-content/
#
wp --path=/var/www/html/ plugin install vcaching --activate
wp --path=/var/www/html/ option update varnish_caching_enable 1 || wp --path=/var/www/html/ option add varnish_caching_enable 1
wp --path=/var/www/html/ option update varnish_caching_homepage_ttl 60  || wp --path=/var/www/html/ option add varnish_caching_homepage_ttl 60
wp --path=/var/www/html/ option update varnish_caching_ttl 600 || wp --path=/var/www/html/ option add varnish_caching_ttl 600
wp --path=/var/www/html/ option update varnish_caching_ips $(grep 'VARNIS_IP' /scripts/property.cfg | sed 's/^.*=//g') || wp --path=/var/www/html/ option add varnish_caching_ips $(grep 'VARNIS_IP' /scripts/property.cfg | sed 's/^.*=//g')
wp --path=/var/www/html/ option update varnish_caching_varnish_backends $(grep 'WP_IP' /scripts/property.cfg | sed 's/^.*=//g') || wp --path=/var/www/html/ option add varnish_caching_varnish_backends $(grep 'WP_IP' /scripts/property.cfg | sed 's/^.*=//g')
wp --path=/var/www/html/ option update varnish_caching_varnish_acls $(grep 'WP_IP' /scripts/property.cfg | sed 's/^.*=//g') || wp --path=/var/www/html/ option add varnish_caching_varnish_acls $(grep 'WP_IP' /scripts/property.cfg | sed 's/^.*=//g')
wp --path=/var/www/html/ option update varnish_caching_stats_json_file /varnishstat.json || wp --path=/var/www/html/ option add varnish_caching_stats_json_file /varnishstat.json
#
wp --path=/var/www/html/ plugin update --all
wp --path=/var/www/html/ theme update --all
wp --path=/var/www/html/ core update
wp --path=/var/www/html/ core update-db
"
#
#
# #
#
#
# varnish_caching_homepage_ttl 60
# varnish_caching_ttl 600
# varnish_caching_ips
#
#
# --- wp --path=/var/www/html/ plugin install varnish-http-purge --activate
# --- wp --path=/var/www/html/ option update vhp_varnish_ip 172.3.14.12 || wp --path=/var/www/html/ option add vhp_varnish_ip 172.3.14.12
