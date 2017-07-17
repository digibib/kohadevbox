#!/bin/bash

sudo apt-get update -q
ANSIBLE_VERSION=`apt-cache show ansible | grep Version | cut -f2 -d' ' | sort -r | head -1`
if [[ "$ANSIBLE_VERSION" < "2.1" ]]; then
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367
    sudo apt-get install -q -y software-properties-common
    sudo apt-add-repository -y "deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main"
    sudo apt-get update -q
    ANSIBLE_VERSION=`apt-cache show ansible | grep Version | cut -f2 -d' ' | sort -r | head -1`
fi
sudo apt-get install -y -q ansible=$ANSIBLE_VERSION
