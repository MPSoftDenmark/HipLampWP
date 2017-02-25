#/bin/bash
docker exec -it wordpress /bin/bash -c "test -f && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
test -f && chmod +x wp-cli.phar; \
test -f && mv wp-cli.phar /usr/local/bin/wp; \
sed -i 's|www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin|www-data:x:33:33:www-data:/var/www:/bin/bash|g' /etc/passwd"
#docker exec -it wordpress /bin/bash -c "su - www-data -c 'wp --info --allow-root'"
--dbname=
--dbuser=
--dbpass=
--dbhost=
--dbprefix=
[--extra-php]


#
docker exec -it wordpress /bin/bash -c "su - www-data -c 'wp plugin install redis-cache --activate --path=/var/www/html/ ' "
docker exec -it wordpress /bin/bash -c "su - www-data -c 'cp -v /var/www/html/wp-content/plugins/redis-object-cache/object-cache.php /var/www/html/wp-content/ ' "
docker exec -it wordpress /bin/bash -c "sed -i '/define.*WP_DEBUG/a define( '\''WP_REDIS_HOST'\'', '\''redis.dlan'\'');' /var/www/html/wp-config.php"
#
docker exec -it wordpress /bin/bash -c "su - www-data -c 'wp plugin install varnish-http-purge --activate --path=/var/www/html/' "
docker exec -it mysql /bin/bash -c "echo 'INSERT INTO \`wp_options\` (\`option_id\`, \`option_name\`, \`option_value\`, \`autoload\`) VALUES (NULL, '\''vhp_varnish_ip'\'', '\''172.3.14.12'\'', '\''yes'\'');' | mysql -v -hmysql.dlan -uwordpress -pwordpress wordpress "
#
#docker exec -it mysql /bin/bash -c "echo 'SELECT option_id INTO @id FROM wp_options WHERE option_name = '\''vhp_varnish_ip'\''; UPDATE wp_options SET option_value = '\''172.3.14.12'\'' WHERE wp_options.option_id = @id;' | mysql -v -uwordpress -pwordpress wordpress"
#
docker exec -it wordpress /bin/bash -c "su - www-data -c 'wp plugin update --all --path='\''/var/www/html/'\'' ' "
# wp theme update --all
docker exec -it wordpress /bin/bash -c "su - www-data -c 'wp theme update --all --path='\''/var/www/html/'\'' ' "
#wp core update
docker exec -it wordpress /bin/bash -c "su - www-data -c 'wp core update --path='\''/var/www/html/'\'' ' "
#wp core update-db
docker exec -it wordpress /bin/bash -c "su - www-data -c 'wp core update-db --path='\''/var/www/html/'\'' ' "
