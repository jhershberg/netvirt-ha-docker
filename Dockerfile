FROM fedora:latest
RUN yum install -y java-1.8.0-openjdk-devel iproute iputils procps-ng tcpdump vim
RUN mkdir -p /netvirt/karaf/target/assembly/configuration
RUN mkdir -p /netvirt/karaf/target/assembly/etc
RUN mkdir -p /netvirt/karaf/target/assembly/system
COPY configuration/* /netvirt/karaf/target/assembly/configuration/
COPY etc/* /netvirt/karaf/target/assembly/etc/
COPY system/* /netvirt/karaf/target/assembly/system/

#ENV OVS_VERSION 2.5.1
#ENV OVS_RPM openvswitch-${OVS_VERSION}-1.fc22.x86_64.rpm
## Configure supervisord
#RUN mkdir -p /var/log/supervisor/
#ADD supervisord.conf /etc/
#
## Install supervisor_stdout
#WORKDIR /opt
#RUN mkdir -p /var/log/supervisor/
#RUN mkdir -p /etc/openvswitch
#RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
#    python get-pip.py && \
#    pip install setuptools && \
#    pip install supervisor && \
#    pip install supervisor-stdout
#
## Get Open vSwitch
#ADD $OVS_RPM /root
#WORKDIR /root
#RUN yum install -y openssl iproute && \
#    rpm -i $OVS_RPM && \
#    rm -v $OVS_RPM && \
#    yum -v clean all && \
#    mkdir -p /var/run/openvswitch/ && \
#    mkdir /dev/net && \
#    mknod /dev/net/tun c 10 200
#ADD configure-ovs.sh /usr/share/openvswitch/
#ADD mk-net-dev.sh /usr/share/openvswitch/
## Create the database
#RUN ovsdb-tool create /etc/openvswitch/conf.db /usr/share/openvswitch/vswitch.ovsschema
#CMD ["/usr/bin/supervisord"]
