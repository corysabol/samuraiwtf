FROM jenkins/jenkins:2.60.1

# Distributed builds plugins
#RUN /usr/local/bin/install-plugins.sh ssh-slaves

## install notifications and publishing plugins
#RUN /usr/local/bin/install-plugins.sh email-ext
#RUN /usr/local/bin/install-plugins.sh mailer
#RUN /usr/local/bin/install-plugins.sh slack

# Artifiacts
RUN /usr/local/bin/install-plugins.sh htmlpublisher

# UI
RUN /usr/local/bin/install-plugins.sh greenballs
RUN /usr/local/bin/install-plugins.sh simple-theme-plugin

# Scaling
RUN /usr/local/bin/install-plugins.sh kubernetes

# install Maven
USER root
RUN apt-get update && apt-get install -y maven
USER jenkins
