#!/bin/bash

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7BB9C367
sudo apt-get install -q -y software-properties-common
sudo apt-add-repository -y "deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main"
sudo apt-get update -q
sudo apt-get install -y -q ansible