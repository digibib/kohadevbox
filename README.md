# KohaDevBox

Uses Vagrant to set up a VirtalBox ready to do development and signoffs on the
Koha project. 

## What you get

* Debian 7.6
* Latest version of koha-common based on the master branch
* A clone of the official Koha Git repo
* A gitified Koha instance, running off the repo
* A remote for your own repo on e.g. GitHub
* Git bz set up and ready to use

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

## Tests

KohaDevBox comes with some tests to verify that the environment inside the
VirtualBox is set up as intended. To run these tests, run the following commands
inside the VirtualBox:

```
  $ cd /vagrant
  $ prove
```

## Code, issues etc

https://github.com/digibib/kohadevbox/
