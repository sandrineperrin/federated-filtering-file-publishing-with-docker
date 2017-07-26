FROM debian:8

#will run apache
CMD apache2ctl -D FOREGROUND

#on port 80
EXPOSE 80

RUN apt-get update && apt-get install -y \
		apache2 \
		nano \
		wget \
		gcc \
		libjansson4 \
		libhiredis0.10 \
	        libcurl3 \
	&& wget --quiet --output-document=/tmp/libcjose.deb https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.0.0/libcjose_0.4.1-1_amd64.deb \
	&& wget --quiet --output-document=/tmp/oidc.deb https://github.com/pingidentity/mod_auth_openidc/releases/download/v2.0.0/libapache2-mod-auth-openidc_2.0.0-1_amd64.deb \
	&& dpkg -i /tmp/libcjose.deb /tmp/oidc.deb \
	&& rm -f /tmp/oidc.deb /tmp/libcjose.deb \
	&& rm -rf /var/lib/apt/lists/*

# Update apache2 conf
RUN sed -i -e '59 iServerSignature Off' -e '59 iServerTokens Prod' -e '59 iTraceEnable off' /etc/apache2/apache2.conf \
        && sed -i -e '133 iErrorDocument 503 /errors/custom_50x.html' /etc/apache2/apache2.conf \
        && service apache2 restart

WORKDIR /var/www/html/errors/
RUN echo '<html>' >> custom_50x.html \
        && echo '<h1> Requested service not available. </h1>' >> custom_50x.html \
        && echo '<p>  If the problem persists, please contact the support. </p>' >> custom_50x.html \
        && echo '</html>' >> custom_50x.html

WORKDIR /

RUN a2enmod \
		auth_openidc \
		ssl \
		authz_groupfile \
		proxy_http

