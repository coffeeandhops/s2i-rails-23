
# https://github.com/sclorg/s2i-ruby-container/blob/master/2.3/Dockerfile
# coffeeandhops/s2i-rails-23
FROM openshift/base-centos7

MAINTAINER Your Name <jason@coffeeandhops.com>

ENV BUILDER_VERSION 1.0

LABEL summary="Platform for building and running Rails on Ruby 2.3 including extra packages" \
      io.k8s.description="Platform for building and running Rails on Ruby 2.3 including extra packages" \
      io.k8s.display-name="Ruby 2.3" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,ruby,ruby23,rh-ruby23,rails"


RUN yum install -y centos-release-scl && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="rh-ruby23 rh-ruby23-ruby-devel rh-ruby23-rubygem-rake rh-ruby23-rubygem-bundler rh-nodejs4" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && rpm -V $INSTALL_PKGS && \
    yum clean all -y

COPY ./.s2i/bin/ $STI_SCRIPTS_PATH

# COPY ./.s2i/bin/ /usr/libexec/s2i

COPY ./contrib/ /opt/app-root
COPY ./migrate-database.sh migrate-database.sh 
COPY ./create-database.sh create-database.sh 

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root
RUN chown -R 1001:0 /opt/app-root && chmod -R ug+rwx /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# ENTRYPOINT ["./migrate-database.sh"]

# TODO: Set the default port for applications built using this image
EXPOSE 8080

CMD $STI_SCRIPTS_PATH/usage

