#!/usr/bin/env bash

set -ex

SUCCESS_INDICATOR=/opt/.vagrant_provision_success
DATA_SOURCE=/var/lib/cloud/seed/nocloud-net
META_DATA=/tmp/vagrant/cloud-init/nocloud-net/meta-data
USER_DATA=/tmp/vagrant/cloud-init/nocloud-net/user-data

# confirm this is a centos box
[[ ! -f /etc/centos-release ]] && exit 1

# check if vagrant_provision has run before
[[ -f $SUCCESS_INDICATOR ]] && exit 0

yum install -y epel-release
yum install -y cloud-init avahi nss-mdns

# HACK: mDNS has an issue where other clients cannot resolve this host after vagrant halt/suspend
hostname "$1"

# enable Multicast DNS
sed -i.bak -e 's/^hosts:.*/hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4/g' /etc/nsswitch.conf
systemctl restart avahi-daemon
systemctl enable avahi-daemon

# HACK: mDNS has an issue where other clients cannot resolve this host after vagrant halt/suspend
cat << EOF > /etc/NetworkManager/dispatcher.d/ifup-local
#!/bin/sh

case "\$1" in
    eth*)
        # Record event in /var/log/messages
        logger "\$1 has come up... resetting hostname to $1 and restarting avahi-daemon.service - this is a hack"
        hostname "$1"
        systemctl restart avahi-daemon.service
        ;;
esac

exit 0
EOF
chmod 700 /etc/NetworkManager/dispatcher.d/ifup-local

# write cloud-init files
mkdir -p $DATA_SOURCE
[[ -f $META_DATA ]] && cp $META_DATA $DATA_SOURCE/ || exit 1
[[ -f $USER_DATA ]] && cp $USER_DATA $DATA_SOURCE/ || exit 1

# force cloud-init to run
cloud-init init
cloud-init modules

# create vagrant_provision on successful run
touch $SUCCESS_INDICATOR

exit 0
