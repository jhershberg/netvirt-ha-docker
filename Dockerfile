FROM fedora:latest
RUN yum install -y java-1.8.0-openjdk-devel iproute iputils procps-ng tcpdump vim
RUN mkdir -p /odlha/karaf/target/assembly
