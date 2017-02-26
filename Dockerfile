FROM debian
MAINTAINER Peter Kerekes <mail@kerekespeterjanso.hu>
RUN apt-get update -qq && apt-get upgrade -qqy && apt-get install cron -y --force-yes && apt-get install varnish -qqy && apt-get install -fqqy && apt-get autoremove -qqy && rm -rf /var/lib/apt/lists/* && \
mkdir -p /var/www/html/ && echo "SHELL='/bin/bash'
PATH='/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
*/3 * * * * /usr/bin/varnishstat -1j > /var/www/html/varnishstat.json && chmod 644 /var/www/html/varnishstat.json" >> /etc/cron.d/varnishstat && \
chmod 777 /etc/cron.d/varnishstat && touch /var/log/cron.log
ADD crontab /etc/cron.d/varnishstat
CMD ["/usr/sbin/varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-a", ":80", "-T", "localhost:6082", "-S", "/etc/varnish/secret", "-s", "malloc,256m"]
CMD ["/etc/init.d/cron", "start"]
#https://groups.google.com/forum/#!topic/docker-user/4lHq_fZz1zY
