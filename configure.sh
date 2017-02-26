#!/bin/bash
 WP_INIT () {
docker cp scripts/wp_init.sh wordpress:/
docker exec -it wordpress /bin/bash -c 'sh /wp_init.sh'
sed -i "s/host = '.*'/host = $(grep 'WP_IP' ./scripts/property.cfg | sed 's/^.*=//g')/g" ./varnish/etc/varnish/conf/backend.vcl
sed -i "s/port = '.*'/port = $(grep 'WP_PORT' ./scripts/property.cfg | sed 's/^.*=//g')/g" ./varnish/etc/varnish/conf/backend.vcl
sed  "/127.0.0.1/a\
$(grep 'WP_IP' ./scripts/property.cfg | sed 's/^.*=//g');
" ./varnish/etc/varnish/conf/acl.vcl
docker exec -it varnish /bin/bash -c 'crontab /scripts/crontab'
docker restart varnish && sleep 2 && docker ps | grep varnish
}
#
WP_RESTORE (){
echo 'tmp'
}
#
PRINT_HELP (){
echo '
    -c --wpconfigure    Configure WP'
echo '
    -r --wprestore      Restore WP from BackWPup backup
'
}
#
case $1 in
--wpconfigure|-c) WP_INIT ;;
--wprestore|-r) WP_RESTORE ;;
* ) PRINT_HELP ;;
esac
