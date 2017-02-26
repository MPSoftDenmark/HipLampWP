FROM debian
MAINTAINER Peter Kerekes <mail@kerekespeterjanso.hu>
RUN DEBIAN_FRONTEND=noninteractive && \
DEBIAN_PRIORITY=critical && \
apt-get -qq update && \
apt-get -qqy install cron varnish && \
apt-get -qqy autoremove && \
rm -rf /var/lib/apt/lists/* && \
mkdir -p /var/www/html/ && \
echo 'SHELL=/bin/bash' >> /etc/cron.d/varnishstat && \
echo 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' >> /etc/cron.d/varnishstat && \
echo '*/3 * * * * /usr/bin/varnishstat -1j > /var/www/html/varnishstat.json && chmod 644 /var/www/html/varnishstat.json' >> /etc/cron.d/varnishstat && \
chmod 777 /etc/cron.d/varnishstat && \
touch /var/log/cron.log
#CMD ["/etc/init.d/cron", "start", "&&", "/usr/bin/crontab", "/etc/cron.d/varnishstat", "&&", "/usr/sbin/varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-a", ":80", "-T", "localhost:6082", "-S", "/etc/varnish/secret", "-s", "malloc,256m"]
CMD ["/usr/sbin/varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-a", ":80", "-T", "localhost:6082", "-S", "/etc/varnish/secret", "-s", "malloc,256m"]
#https://groups.google.com/forum/#!topic/docker-user/4lHq_fZz1zY
#https://raymii.org/s/tutorials/Silent-automatic-apt-get-upgrade.html
#apt-get install -fqqy && \
#&& touch /var/www/html/varnishstat.json
#root@varnish:/# /etc/init.d/cron start
#root@varnish:/# /usr/bin/crontab /etc/cron.d/varnishstat
