FROM ubuntu:16.04
MAINTAINER Levi Govaerts <legovaer@me.com>

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
        software-properties-common \
 && apt-add-repository ppa:git-core/ppa \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
        curl \
        git \
        tzdata \
        rubygems \
        libcurl3 \
        libicu55 \
        libunwind8 \
        supervisor \
        vim \
 && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
 && apt-get install -y --no-install-recommends git-lfs \
 && rm -rf /var/lib/apt/lists/*

# Set correct timezone
RUN echo "Europe/Brussels" > /etc/timezone \
 && rm /etc/localtime \
 && dpkg-reconfigure -f noninteractive tzdata

# Accept the TEE EULA
RUN mkdir -p "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && cd "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && echo '<ProductIdData><eula-14.0 value="true"/></ProductIdData>' > "com.microsoft.tfs.client.productid.xml"

# Install Capistrano
RUN apt-get update -y
RUN apt-get install rubygems ruby-dev -y
RUN /bin/bash -l -c "gem install capistrano"

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