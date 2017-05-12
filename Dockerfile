FROM ubuntu:16.04
MAINTAINER Levi Govaerts <legovaer@me.com>

# Set MySQL Root password
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        software-properties-common \
 && apt-add-repository ppa:git-core/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        curl \
        git \
        libcurl3 \
        libicu55 \
        libunwind8 \
        mysql-client \
        mysql-server \
        php7.0-cli \
        php7.0-mbstring \
        php7.0-zip \
        php7.0-mcrypt \
        php7.0-gmp \
        php7.0-xml \
        php7.0-curl \
        php7.0-gd \
        php7.0-mysql \
        php7.0-sqlite3 \
        supervisor \
        vim \
 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
 && apt-get install -y --no-install-recommends git-lfs \
 && rm -rf /var/lib/apt/lists/*

# Set correct timezone
RUN echo "Europe/Brussels" > /etc/timezone \
 && rm /etc/localtime \
 && dpkg-reconfigure -f noninteractive tzdata

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Drush 8.
RUN composer global require drush/drush:8.*
RUN composer global update
# Unfortunately, adding the composer vendor dir to the PATH doesn't seem to work. So:
RUN ln -s /root/.composer/vendor/bin/drush /usr/local/bin/drush

# Install Drupal Console. There are no stable releases yet, so set the minimum
# stability to dev.
RUN curl https://drupalconsole.com/installer -L -o drupal.phar && \
	mv drupal.phar /usr/local/bin/drupal && \
	chmod +x /usr/local/bin/drupal

# Setup Supervisor.
RUN echo '[program:mysql]\ncommand=/usr/bin/pidproxy /var/run/mysqld/mysqld.pid /usr/sbin/mysqld\nautorestart=true\n\n' >> /etc/supervisor/supervisord.conf
RUN echo '[program:vsts]\ncommand=/vsts/start.sh\nautorestart=true' >> /etc/supervisor/supervisord.conf

# Accept the TEE EULA
RUN mkdir -p "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && cd "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && echo '<ProductIdData><eula-14.0 value="true"/></ProductIdData>' > "com.microsoft.tfs.client.productid.xml"

WORKDIR /vsts

RUN set -x \
 && curl -fSL https://github.com/Microsoft/vsts-agent/releases/download/v2.105.7/vsts-agent-ubuntu.16.04-x64-2.105.7.tar.gz -o agent.tgz \
 && mkdir agent \
 && cd agent \
 && tar -xzf ../agent.tgz \
 && chown -R root:root . \
 && cd .. \
 && rm agent.tgz

COPY ./start.sh .
RUN chmod +x start.sh

EXPOSE 22
CMD exec supervisord -n
