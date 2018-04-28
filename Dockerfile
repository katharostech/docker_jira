################
# JIRA Image
################

# Set the base image
FROM registry.access.redhat.com/rhel7

# File Author / Maintainer
MAINTAINER dhaws opax@kadima.solutions

# Build Args
ARG JIRA_VERSION
ARG JIRA_DOWNLOAD_URL=https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-${JIRA_VERSION}.tar.gz
ARG MYSQL_JDBC_DRIVER_VERSION=5.1.43
ARG MYSQL_DRIVER_DOWNLOAD_URL=http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_JDBC_DRIVER_VERSION}.tar.gz

# Environment variables
# JIRA 
ENV JIRA_HOME                   /var/atlassian/application-data/jira
ENV JIRA_INSTALL                /opt/atlassian/jira
ENV JIRA_VERSION                $JIRA_VERSION
ENV JIRA_DOWNLOAD_URL           $JIRA_DOWNLOAD_URL

# MySQL
ENV MYSQL_JDBC_DRIVER_VERSION   $MYSQL_JDBC_DRIVER_VERSION
ENV MYSQL_DRIVER_DOWNLOAD_URL   $MYSQL_DRIVER_DOWNLOAD_URL
# User
ENV RUN_USER            jira
ENV RUN_GROUP           devops

# Setting Java home directory as env var inside of container
ENV JAVA_HOME					 /usr/java/jdk1.8.0_162

# Create unprivileged account
RUN set -x && \
groupadd ${RUN_GROUP} && \
useradd -g ${RUN_GROUP} ${RUN_USER}

# Add pre-install files
COPY jdk-8u162-linux-x64.rpm /
RUN \
chmod 644 /jdk-8u162-linux-x64.rpm

# Update system and install any necessary utilities
# Utilities
RUN set -x \
&& yum-config-manager --enable rhel-7-server-thirdparty-oracle-java-rpms \
&& yum localinstall -y jdk-8u162-linux-x64.rpm \
&& yum clean all \ 
&& java -version

# Install Jira
RUN set -x \
&& mkdir -p ${JIRA_INSTALL} \
&& curl -Ls "${JIRA_DOWNLOAD_URL}" | tar -xz -C "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
&& curl -Ls "${MYSQL_DRIVER_DOWNLOAD_URL}" | tar -xz -C "${JIRA_INSTALL}/atlassian-jira/WEB-INF/lib" --strip-components=1 --no-same-owner "mysql-connector-java-${MYSQL_JDBC_DRIVER_VERSION}/mysql-connector-java-${MYSQL_JDBC_DRIVER_VERSION}-bin.jar" \
&& chmod -R 700 ${JIRA_INSTALL} \
&& chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_INSTALL} \
&& mkdir -p ${JIRA_HOME} \
&& chmod -R 700 ${JIRA_HOME} \
&& chown -R ${RUN_USER}:${RUN_GROUP} ${JIRA_HOME}

# Setup configurable memory parameters
RUN set -x \
&& sed -i '/^JVM_MIN/c\JVM_MINIMUM_MEMORY="${JVM_MIN_MEM:-512m}"' ${JIRA_INSTALL}/bin/setenv.sh \
&& sed -i '/^JVM_MAX/c\JVM_MAXIMUM_MEMORY="${JVM_MAX_MEM:-1024m}"' ${JIRA_INSTALL}/bin/setenv.sh \
&& sed -i '/^JVM_SUPPORT_RECOMMENDED_ARGS/c\JVM_SUPPORT_RECOMMENDED_ARGS="${JVM_SUPPORT_RECOMMENDED_ARGS}"' ${JIRA_INSTALL}/bin/setenv.sh

# Add post install scripts
COPY docker-cmd.sh /docker-cmd.sh
RUN chmod 744 /docker-cmd.sh
#
COPY jira-cfg.sh /jira-cfg.sh
RUN chmod 744 /jira-cfg.sh

# Expose the Jira port
EXPOSE 8080

# Run this on container startup
CMD ["./docker-cmd.sh"]
