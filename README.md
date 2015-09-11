# KohaDevBox

Uses Vagrant to set up a VirtualBox ready to do development and signoffs on the
Koha project.

##### The KohaDevBox is not suitable for running Koha in production.

## What you get

* A virtual machine running either:

  - Debian 7 (wheezy)
  - Debian 8 (jessie)
  - Ubuntu 14.04 (trusty)

* Latest version of koha-common from the unstable repository (based on the master branch)
* A clone of the official Koha Git repo
* A gitified Koha instance, running off the repo, under Apache
* A remote for your own repo on e.g. GitHub
* Git bz set up and ready to use
* Koha's qa-test-tools set up and ready to use

See the [open issues](https://github.com/digibib/kohadevbox/issues) for more to come.

## Getting started

Register with Bugzilla, Koha's bug tracker, if you have not done so already:

http://bugs.koha-community.org/bugzilla3/createaccount.cgi

You will need to put your username and password in config.cfg (see below), so
do not use a password you have used on other sites.

If you don't have them already, you need to install some prerequisites:

* Install Vagrant: http://www.vagrantup.com/downloads.html

  Note: Ubuntu and Debian ship their own vagrant package, but don't use it. Download the latest version from the above URL.

* Install Git: http://git-scm.com/downloads

Now you can clone the KohaDevBox repository to your local machine and cd into
the directory that was created by the cloning operation:

```
  $ git clone https://github.com/digibib/kohadevbox.git
  $ cd kohadevbox
```

## Usage

### vars/user.yml

Uncomment the lines you would like to change. Usually your personal information,
including your email and bugzilla password.

### Running Vagrant

Before you start using Vagrant, you will probably want to do this, to speed up
the future installation of packages etc in your VirtualBox:

```
  $ vagrant plugin install vagrant-cachier
```

To spin up a new dev box. You need to specify either wheezy, trusty or jessie:

```
  $ vagrant up <distribution>
```

This will download and install a bunch of stuff, please be patient. When
everything is done, you should be able to access your dev installation of Koha
at these addresses:

* http://localhost:8080/ Public interface (Apache)
* http://localhost:8081/ Staff interface (Apache)

Until issue #2 has been fixed, you need to log in to the Web UI with the
database user. You will find the username and password in this file:

```
/etc/koha/sites/<instance_name>/koha-conf.xml
```

To log into the newly created box:

```
  $ vagrant ssh <distribution>
```

To exit the box, just type "exit".

To save the state of the box, so you can return to it later:

```
  $ vagrant halt
```

To destroy the box and all its contents:

```
  $ vagrant destroy
```

## Aliases

Some aliases are provided to help reduce typing:

* koha-intra-err - tail the intranet error log
* koha-opac-err - tail the OPAC error log
* koha-user - get the db/admin username from koha-conf.xml
* koha-pass - get the db/admin password from koha-conf.xml

## Environment variables

Some of the behaviour of KohaDevBox can be altered through the use of environment
variables. These can be set in a few different ways, depending on how permanent
you want to make them:

On the command line when you run "vagrant up". This will only affect one run of
"vagrant up", and you can change it or leave it out the next time you run
"vagrant up":

```
  $ SYNC_REPO="/home/me/kohaclone" vagrant up
```

On the command line, with export. This will remain in effect for the duration
of your current shell session:

```
  $ export SYNC_REPO="/home/me/kohaclone"
```

In your ~/.bashrc. This will make sure the environment variable is set every
time you start a new shell session:

```
  export SYNC_REPO="/home/me/kohaclone"
```

The available environment variables are:

### SYNC_REPO

Value: The path to an existing Koha Git repo.

Usage:

```
  $ SYNC_REPO="/home/me/kohaclone" vagrant up
```

Sometimes you have an existing Koha Git repo, that you want to "take with you"
into the VirtualBox created by KohaDevBox. Or you want to save some time by
not having KohaDevBox clone lots of large repos every time you spin up a new
box. Or you want to be able to work on the code with your usual tools, regardless
of what is available inside the VirtualBox. Or you have some code that you want
to test on a fresh virtual machine. Then this environment variable is for you.

Please note:

* The repo is synced "both ways", so any changes you make to the repo while you
are inside the box will persist in your repo once you shut down or destroy the
box.
* When you do "vagrant up", the Koha instance configured by the box will run
off whatever branch you had checked out in your pre-existing repo when you ran
"vagrant up".

## qa-test-tools

An alias is set up so that you can easily run Koha's qa-test-tools when you are
inside your Koha repository clone:

```
  $ qa -c 7 -v 2
```

However, this will probably result in complaints that koha-conf.xml can not be
found. To avoid this, you can run qa-test-tools through koha-shell like this:

```
  $ sudo koha-shell -c "perl -I/home/vagrant/qa-test-tools/ /home/vagrant/qa-test-tools/koha-qa.pl -c 7 -v 2" kohadev
```

## Tests

KohaDevBox comes with some tests to verify that the environment inside the
VirtualBox is set up as intended. To run these tests, run the following commands
inside the VirtualBox:

```
  $ cd /vagrant
  $ prove
```

## Koha documentation for developers

The [Developer Handbook](http://wiki.koha-community.org/wiki/Developer_handbook)
is the main point of entry into the Koha wiki for new and aspiring developers
and people who want to sign off on patches. Here are some shortcuts:

General stuff that everyone should know:

* [Bug-enhancement-patch Workflow](http://wiki.koha-community.org/wiki/Bug-enhancement-patch_Workflow)
* [Git bz](http://wiki.koha-community.org/wiki/Git_bz_configuration) is a handy tool to reduce typing

Signing off on patches:

* [Sign off on patches](http://wiki.koha-community.org/wiki/Sign_off_on_patches)

Doing development:

* [Coding Guidelines](http://wiki.koha-community.org/wiki/Coding_Guidelines)
* [Version Control Using Git](http://wiki.koha-community.org/wiki/Version_Control_Using_Git)
* [Commit messages](http://wiki.koha-community.org/wiki/Commit_messages)
* [Unit Tests](http://wiki.koha-community.org/wiki/Unit_Tests)
* [Database updates](http://wiki.koha-community.org/wiki/Database_updates)
* [Adding a syspref](http://wiki.koha-community.org/wiki/System_Preferences#Adding_a_new_system_preference)

The [Koha Documentation](http://koha-community.org/documentation/) is highly
recommended for getting to know Koha in general.

## Code, issues etc

https://github.com/digibib/kohadevbox/
