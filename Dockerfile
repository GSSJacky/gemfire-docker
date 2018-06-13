# LICENSE GPL 2.0
#Set the base image :
FROM ubuntu:14.04


#File Author/Maintainer :
MAINTAINER XXXXXX <xxxxxx@gmail.com>

###################
# for example: 
# jdk-8u172-linux-x64.tar.gz download URL
# http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz
# --》
# "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/$JDK_HASH_VALUE/jdk-$JAVA_VERSION-linux-x64.tar.gz"
###################
ENV JAVA_VERSION 8u172
ENV BUILD_VERSION b11
ENV JAVA_SUB_VERSION 172
ENV JDK_HASH_VALUE a58eab1ec242421181065cdc37240b08

##################
# Gemfire version
##################
ENV GEMFIREVERSION 9.2.0

#Set workdir :
WORKDIR /opt/pivotal

RUN apt-get update && apt-get install -y wget

#Obtain/download Java SE Development Kit 8u172 using wget :
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/$JDK_HASH_VALUE/jdk-$JAVA_VERSION-linux-x64.tar.gz"

#Set permissions to gemfire directory to perform operations :
RUN chmod 777 /opt/pivotal

#Setup jdk1.8.x_xx and create softlink :
RUN gunzip jdk-$JAVA_VERSION-linux-x64.tar.gz
RUN tar -xvf jdk-$JAVA_VERSION-linux-x64.tar
RUN ln -s jdk1.8.0_$JAVA_SUB_VERSION current_java
RUN rm jdk-$JAVA_VERSION-linux-x64.tar

#setup unzip 
RUN apt-get update
RUN apt-get install -y unzip zip


#Add gemfire installation file
ADD ./gemfireproductlist/pivotal-gemfire-$GEMFIREVERSION.zip /opt/pivotal/

#Set the username to root :
USER root

#Install pivotal gemfire :
RUN unzip pivotal-gemfire-$GEMFIREVERSION.zip && \
    rm pivotal-gemfire-$GEMFIREVERSION.zip

#Setup environment variables :
ENV JAVA_HOME /opt/pivotal/current_java
ENV PATH $PATH:/opt/pivotal/current_java:/opt/pivotal/current_java/bin:/opt/pivotal/pivotal-gemfire-$GEMFIREVERSION/bin
ENV GEMFIRE /opt/pivotal/pivotal-gemfire-$GEMFIREVERSION
ENV GF_JAVA /opt/pivotal/current_java/bin/java

#classpath setting
ENV CLASSPATH $GEMFIRE/lib/geode-dependencies.jar:$GEMFIRE/lib/gfsh-dependencies.jar:/opt/pivotal/workdir/classes:$CLASSPATH

#COPY the start scripts into container
COPY workdir /opt/pivotal/workdir

# This trustore file is for PCC lab21
# COPY lab21.truststore lab21.truststore

# Default ports:
# RMI/JMX 1099
# REST 8080
# PULSE 7070
# LOCATOR 10334
# CACHESERVER 40404
# UDP port: 53160
EXPOSE  8080 10334 40404 40405 1099 7070

# SET VOLUME directory
VOLUME ["/opt/pivotal/workdir/storage"]

#ReSet workdir :
WORKDIR /opt/pivotal/workdir
