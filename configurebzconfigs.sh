#!/bin/bash

echo "Koha git-bz configuration setting script"
git config bz.default-tracker bugs.koha-community.org
git config bz.default-product Koha
git config --global bz-tracker.bugs.koha-community.org.path /bugzilla3
git config --global bz-tracker.bugs.koha-community.org.https true
git config --global core.whitespace trailing-space,space-before-tab
git config --global apply.whitespace fix

read -p "Enter your Koha Bugzilla username: " username
git config --global bz-tracker.bugs.koha-community.org.bz-user $username

read -p "Enter your Bugzilla password: " password
git config --global bz-tracker.bugs.koha-community.org.bz-password $password

          
