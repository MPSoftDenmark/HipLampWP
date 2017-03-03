#!/bin/bash
 WP_INIT () {
docker exec -it wordpress /bin/bash -c 'sh /scripts/wp_init.sh'
sed -i "s/host = '.*'/host = $(grep 'WP_IP' ./scripts/property.cfg | sed 's/^.*=//g')/g" ./varnish/etc/varnish/conf/backend.vcl
sed -i "s/port = '.*'/port = $(grep 'WP_PORT' ./scripts/property.cfg | sed 's/^.*=//g')/g" ./varnish/etc/varnish/conf/backend.vcl
sed -i "/127.0.0.1/a\
$(grep 'WP_IP' ./scripts/property.cfg | sed 's/^.*=//g');
" ./varnish/etc/varnish/conf/acl.vcl
docker restart varnish && sleep 2 && docker ps | grep varnish
docker exec -it varnish /bin/bash -c '/etc/init.d/cron start && /usr/bin/crontab /etc/cron.d/varnishstat'
}
# /etc/init.d/cron start
# /usr/bin/crontab /etc/cron.d/varnishstat
#
WP_RESTORE (){
echo 'tmp'
}
#
WP_CLEAN_RESTART (){
docker-compose rm -f
sudo rm -rf wp_db/ wp_html/ && mkdir wp_html/ && touch wp_html/varnishstat.json && echo "### --- OK --- ###"
docker-compose up
}
#
WP_SECURITY (){
docker exec -it wordpress /bin/bash -c 'sh /scripts/wp_security.sh'
}
#
PRINT_HELP (){
echo '
    -c --wpconfigure    1.0 Install / Configure High Performance WordPress
                        1.1 Configure Wordpress - Make wp-config.php
                        1.2 Install WordPress - Add Blog Name;Admin user/pass
                        1.3 Install end Configure plugin:
                            1.3.1 TITLE:       Redis Object Cache
                                  DESCRIPTION: A persistent object cache backend powered by Redis. Supports
                                               Predis, PhpRedis, HHVM, replication, clustering and WP-CLI.
                                  URL:         https://de.wordpress.org/plugins/redis-cache/screenshots/

                            1.3.2 TITLE:       Varnish Caching
                                  DESCRIPTION: Wordpress Varnish Cache 3.x/4.x integration
                                  URL:         https://wordpress.org/plugins/vcaching/

    -s --wpsecurity     2.0 WordPress Security/Hardening - -
                        2.1 Install end Configure plugin:
                            2.1.1 TITLE:       Shield WordPress Security
                                  DESCRIPTION: The Most Comprehensive and Highest-Rated Security System for WordPress
                                               (formerly the WordPress Simple Firewall).
                                  URL: https://de.wordpress.org/plugins/wp-simple-firewall/

    -r --wprestore      Restore WP from BackWPup backup

    -cl --clean         FULL RESET -> !!! Delet all contener end all data files!!!
'
}

#
case $1 in
--wpconfigure|-c) WP_INIT ;;
--wpsecurity|-s) WP_SECURITY ;;
--wprestore|-r) WP_RESTORE ;;
--clean|-cl) WP_CLEAN_RESTART ;;
* ) PRINT_HELP ;;
esac
