# KohaDevBox

Uses Vagrant to set up a VirtalBox ready to do development and signoffs on the
Koha project. 

## What you get

* Debian 7.6
* Latest version of koha-common based on the master branch
* A clone of the official Koha Git repo
* A gitified Koha instance, running off the repo
* A remote for your own repo on e.g. GitHub

See the TODO section for more to come.

## Getting started

If you don't have them already, you need to install some prerequisites:

* Install Vagrant: http://www.vagrantup.com/downloads.html
* Install Git: http://git-scm.com/downloads

Now you can clone the KohaDevBox repository to your local machine and cd into
the directory that was created by the cloning operation:

```
  $ git clone https://github.com/digibib/kohadevbox.git
  $ cd kohadevbox
```

## Usage

Copy the file config.cfg-sample to config.cfg:

```
  $ cp config.cfg-sample config.cfg
```

Read the comments in that file and fill in the config parameters as necessary

To spin up a dev box:

```
  $ vagrant up
```

This will download and install a bunch of stuff, please be patient. When
everything is done, you should be able to access your dev installation of Koha
at these addresses:

* http://localhost:8080/ Public interface
* http://localhost:8081/ Staff interface

To log into the newly created box:

```
  $ vagrant ssh
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

## TODO

* Make things more configurable
* Avoid the web installer
* Create a demo user
* git bz
* qa-test-tools
* Plack
* Memcached
* ElasticSearch
