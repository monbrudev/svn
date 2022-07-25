FROM httpd:2.4
LABEL maintainer="getronics"
LABEL application="svn"

# For information about these parameters see 
# https://httpd.apache.org/docs/2.4/mod/mod_authnz_ldap.html

ARG AuthLDAPURL
ARG AuthLDAPBindDN
ARG AuthLDAPBindPassword
ARG RequireLDAPGroup

RUN apt-get update && apt-get --yes --force-yes --no-install-recommends install curl subversion libapache2-mod-svn net-tools lsof netcat vim ldap-utils  procps\
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/scr
RUN chmod -R 777 /tmp/scr
COPY docker-entrypoint.sh /tmp/scr/docker-entrypoint.sh
RUN chmod 775 /tmp/scr/docker-entrypoint.sh
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
RUN chmod 775 /usr/local/apache2/conf/httpd.conf
RUN chmod 777 -R /usr/local/apache2/logs

#WORKDIR /usr/local/apache2
#RUN echo "Include conf/extra/svn.conf" >> conf/httpd.conf

#VOLUME ["/var/svn"]

RUN mkdir -p /var/svn 
RUN svnadmin create /var/svn

#permitimos el acceso a apache.
RUN chown -R www-data:www-data /var/svn
RUN chmod -R 777 /var/svn


RUN mkdir -p /usr/local/apache2/conf/extra
RUN chmod -R 777 /usr/local/apache2/conf/extra


ENTRYPOINT ["/tmp/scr/docker-entrypoint.sh"]
CMD ["httpd-foreground"]
