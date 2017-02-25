FROM debian
MAINTAINER Peter Kerekes <mail@kerekespeterjanso.hu>
RUN apt-get update -qq && apt-get install varnish -qqy && apt-get install -fqqy && apt-get autoremove -qqy && rm -rf /var/lib/apt/lists/*
CMD ["/usr/sbin/varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-a", ":80", "-T", "localhost:6082", "-S", "/etc/varnish/secret", "-s", "malloc,256m"]
