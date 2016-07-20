FROM centos:7

#will run apache
CMD /usr/sbin/apachectl -DFOREGROUND

#on port 80
EXPOSE 80

# httpd installation
#RUN yum update -y && yum install -y httpd mod_ssl mod_wsgi nano && yum clean -y all

# mod_auth_openidc installation
#RUN yum update -y && yum install -y epel-release && yum -y --nogpgcheck localinstall https://github.com/pingidentity/mod_auth_openidc/releases/download/v1.8.8/mod_auth_openidc-1.8.8-1.el7.centos.x86_64.rpm && yum clean -y all

# all installation
RUN yum update -y && yum install -y epel-release httpd && yum -y --nogpgcheck localinstall https://github.com/pingidentity/mod_auth_openidc/releases/download/v1.8.8/mod_auth_openidc-1.8.8-1.el7.centos.x86_64.rpm && yum clean -y all

# config of the proxy
#COPY ./proxy.conf /etc/httpd/conf.d/proxy.conf

#allowed user
#COPY ./apache_groups /etc/httpd/apache_groups
