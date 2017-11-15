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

# install cloud-init
yum install -y cloud-init

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
