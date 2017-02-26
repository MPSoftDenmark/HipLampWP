#!/bin/bash
 WP_INIT () {
docker cp scripts/wp_init.sh wordpress:/
docker exec -it wordpress /bin/bash -c 'sh /wp_init.sh'
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
PRINT_HELP (){
echo '
    -c --wpconfigure    Configure WP

    -r --wprestore      Restore WP from BackWPup backup

    -cl --clean         FULL RESET -> !!! Delet all contener en all data files!!!
'
}
#
case $1 in
--wpconfigure|-c) WP_INIT ;;
--wprestore|-r) WP_RESTORE ;;
--clean|-cl) WP_CLEAN_RESTART ;;
* ) PRINT_HELP ;;
esac
