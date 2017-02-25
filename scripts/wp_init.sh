#/bin/bash
#
#    docker cp scripts/php-wpcli_1.1.0_all.deb wordpress:/
#
#    docker cp wp_init.sh wordpress:/             docker cp scripts/wp_init.sh wordpress:/
#
#    docker exec -it wordpress /bin/bash -c 'sh /wp_init.sh'
#
apt update && apt install -qqy libdbd-mysql-perl libdbi-perl libjson-c2 libmysqlclient18 libonig2 libperl4-corelibs-perl libqdbm14 libterm-readkey-perl lsof mysql-client mysql-client-5.5 mysql-common php5-cli php5-common php5-json php5-mysql php5-readline psmisc ucf
dpkg -i /php-wpcli_1.1.0_all.deb
#apt install -fy
#
sed -i 's|www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin|www-data:x:33:33:www-data:/var/www:/bin/bash|g' /etc/passwd
su www-data -c "
wp --path=/var/www/html/ core config --dbname=wordpress --dbuser=wordpress --dbpass=wordpress --dbhost=mysql.dlan --dbprefix=dto_ --extra-php <<PHP
define( 'WP_REDIS_HOST', 'redis.dlan' );
PHP
wp --path=/var/www/html/ core install --url='127.0.0.1' --title='Blog Title' --admin_user='root' --admin_password='root123' --admin_email='email@domain.com'
wp --path=/var/www/html/ plugin install redis-cache --activate
cp -v /var/www/html/wp-content/plugins/redis-cache/includes/object-cache.php /var/www/html/wp-content/
wp --path=/var/www/html/ plugin install vcaching --activate
# --- wp --path=/var/www/html/ plugin install varnish-http-purge --activate
# --- wp --path=/var/www/html/ option update vhp_varnish_ip 172.3.14.12 || wp --path=/var/www/html/ option add vhp_varnish_ip 172.3.14.12
wp --path=/var/www/html/ plugin update --all
wp --path=/var/www/html/ theme update --all
wp --path=/var/www/html/ core update
wp --path=/var/www/html/ core update-db
"

#echo "INSERT INTO \`wp_options\` (\`option_id\`, \`option_name\`, \`option_value\`, \`autoload\`) VALUES (NULL, 'vhp_varnish_ip', '172.3.14.12', 'yes');"echo "INSERT INTO \`wp_options\` (\`option_id\`, \`option_name\`, \`option_value\`, \`autoload\`) VALUES (NULL, 'vhp_varnish_ip', '172.3.14.12', 'yes');" | mysql -v -hmysql.dlan -uwordpress -pwordpress wordpress
#
#apt update
#
# wget https://github.com/wp-cli/builds/raw/gh-pages/deb/php-wpcli_1.1.0_all.deb
#
#dpkg -i php-wpcli_1.1.0_all.deb
#
#  php-wpcli depends on php5-cli (>= 5.3.29) | php-cli | php7-cli; however:
#  php-wpcli depends on php5-mysql | php5-mysqlnd | php7.0-mysql; however:
#  php-wpcli depends on mysql-client | mariadb-client; however:
#
#apt install -fy
#The following extra packages will be installed:
#  libdbd-mysql-perl libdbi-perl libjson-c2 libmysqlclient18 libonig2 libperl4-corelibs-perl libqdbm14 libterm-readkey-perl lsof mysql-client mysql-client-5.5 mysql-common php5-cli php5-common php5-json php5-mysql
#  php5-readline psmisc ucf
#Suggested packages:
#  libclone-perl libmldbm-perl libnet-daemon-perl libsql-statement-perl php-pear php5-user-cache
#The following NEW packages will be installed:
#  libdbd-mysql-perl libdbi-perl libjson-c2 libmysqlclient18 libonig2 libperl4-corelibs-perl libqdbm14 libterm-readkey-perl lsof mysql-client mysql-client-5.5 mysql-common php5-cli php5-common php5-json php5-mysql
#  php5-readline psmisc ucf
#0 upgraded, 19 newly installed, 0 to remove and 5 not upgraded.
#1 not fully installed or removed.
#Need to get 7300 kB of archives.
#After this operation, 56.7 MB of additional disk space will be used.
#curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#curl -O https://github.com/wp-cli/builds/raw/gh-pages/deb/$(curl -s https://github.com/wp-cli/builds/tree/gh-pages/deb | egrep -o 'php-wpcli[_\.0-9]*all.deb' | sort -u | head -n1)
#chmod +x wp-cli.phar
#mv wp-cli.phar wp;
