FROM centos:7

ARG ftp_user
ARG ftp_pwd
ARG license_path

ENV JAVA_HOME /usr/lib/jvm/java
ENV PATH=$PATH:$JAVA_HOME

RUN mkdir /tmp/apigee

ADD response.txt /tmp/apigee/response.txt
ADD response-provision.txt /tmp/apigee/response-provision.txt
ADD response-dp.txt /tmp/apigee/response-dp.txt
ADD $license_path /tmp/apigee/license.txt
ADD wait-for-it.sh /wait-for-it.sh

RUN chmod +x /wait-for-it.sh

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN yum install -y wget which openssl && \   
  wget https://software.apigee.com/bootstrap_4.17.09.sh -O /tmp/apigee/bootstrap_4.17.09.sh && \
  wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
  rpm -ivh epel-release-latest-7.noarch.rpm && \
  chmod +x /tmp/apigee/bootstrap_4.17.09.sh

RUN ./tmp/apigee/bootstrap_4.17.09.sh apigeeuser=${ftp_user} apigeepassword=${ftp_pwd} JAVA_FIX=I 
RUN /opt/apigee/apigee-service/bin/apigee-service apigee-setup install

CMD ["/bin/bash"]