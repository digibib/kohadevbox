# KohaDevBox

Create a development environment for the Koha ILS project. It uses Vagrant and Ansible
to set up a VirtualBox. It targets the following tasks:

 * Run all t/ and t/db_dependent tests
 * Sign off patches
 * QA patches
 * Release

##### The KohaDevBox is not suitable for running Koha in production.

## What you get

* A virtual machine running either:

  - Debian 8 (jessie) [*]
  - Debian 7 (wheezy)
  - Ubuntu 16.04 (xenial)
  - Ubuntu 14.04 (trusty)

[*] Default if none specified.

* Latest version of koha-common from the unstable repository (master branch)
  or your custom repository if specified.
* A clone of the official Koha Git repo, or a NFS-mounted git repository from
  your host machine.
* A gitified Koha instance, running off the repo.
* Git-bz set up and ready to use.
* Koha's qa-test-tools set up and ready to use.
* Koha's release-tools set up and ready to use.

See the [open issues](https://github.com/digibib/kohadevbox/issues) for more to come.

## Getting started

## Dependencies

If you don't have them already, you need to install some prerequisites:

* Virtualbox

* Vagrant (version 1.8+): http://www.vagrantup.com/downloads.html

  **Note:** Ubuntu and Debian ship their own vagrant package, but don't use it. Download the latest version from the above URL.

* Ansible (version 1.9+): http://docs.ansible.com/ansible/intro_installation.html
  
  **Note:** Ansible is not required when installing on **Windows** or when using LOCAL_ANSIBLE=1.

* Git: http://git-scm.com/downloads

**Note to Windows users:** The following command-line interactions should take place on the **Git Bash** command line. You may have to run Git Bash as an administrator in order for it to work correctly.

Now you can clone the KohaDevBox repository to your local machine and cd into
the directory that was created by the cloning operation:

```
  $ git clone https://github.com/digibib/kohadevbox.git
  $ cd kohadevbox
  $ git checkout origin/master
```

## Usage

### vars/user.yml

Before you start, you need to create a *vars/user.yml* file. KohaDevBox ships a sample
one. You should run:

```
cp vars/user.yml.sample vars/user.yml
```

And then uncomment the lines you would like to change. Usually your personal information,
including your email and bugzilla password (see below for instructions).

### Running Vagrant

Before you start using Vagrant, you will probably want to do this, to speed up
the future installation of packages etc in your VirtualBox:

```
  $ vagrant plugin install vagrant-cachier
```

To spin up a new dev box. You need to specify either jessie, wheezy or trusty:

```
  $ vagrant up [<distribution>]
```

Note: ommiting the distribution will default to jessie for all the vagrant * commands.

This will download and install a bunch of stuff, please be patient - especially when 
you are not using `SYNC_REPO` (see below), since then the full Koha repository (which is over 
2GiB) will be cloned too.

If the process somehow gets interrupted, hangs, or otherwise does not get completed, 
you may need to force a re-build of the dev box to make sure everything is installed:

```
  $ vagrant halt [<distribution>]
  $ vagrant up --provision [<distribution>]
```

When everything is done, you should be able to access your dev installation of Koha
at these addresses:

* http://localhost:8080/ Public interface (Apache)
* http://localhost:8081/ Staff interface (Apache)

By default, on the staff interface, it will launch the web installer. You can follow the install
wizzard. The required credentials (DB user and password) default to `koha_kohadev` and password
respectively.

You can change the default password on your *vars/user.yml* file before spinning the new box:

```
  # koha_db_password: password
  koha_db_password: your_favourite_password
```

To log into the newly created box:

```
  $ vagrant ssh [<distribution>]
```

To exit the box, just type "exit".

To save the state of the box, so you can return to it later:

```
  $ vagrant halt [<distribution>]
```

To destroy the box and all its contents:

```
  $ vagrant destroy [<distribution>]
```

## Aliases

KohaDevBox ships some aliases to improve productivity. They are divided in two,
depending on the user in which the alias is defined.

Aliases for the *instance* user require that you start a shell with that user in
order to be used. This is done like this:

```
  $ sudo koha-shell kohadev
```

### **vagrant** user
* koha-intra-err - tail the intranet error log
* koha-opac-err - tail the OPAC error log
* koha-plack-log - tail the Plack access log
* koha-plack-err - tail de Plack error log
* koha-user - get the db/admin username from koha-conf.xml
* koha-pass - get the db/admin password from koha-conf.xml
* dbic - recreate the schema files using a fresh DB
* restart_all - restarts memcached, apache and plack
* reset_all   - Drop and recreate the koha database
                Call the misc4dev/do_all_you_can_do.pl script
                    * populate the DB with the sample data
                    * create a superlibrarian user
                    * update the debian files
                    * copy the plack configuration file
                    * restart plack

### **kohadev** user
* **qa**: Run the QA scripts on the current branch. For example: *qa -c 2 -v 2*
* **prove_debug**: Run the *prove* command with all parameters needed for starting
  a remote debugging session.

## Kohadevbox on Windows

Running kohadevbox on Windows requires the use of a native Windows feature called
Samba (usually written as its acronym "SMB" or "smb"). On Windows, after running
`vagrant up` you will be prompted for your Windows username and password.

In order for SMB functionality to work on Vagrant, [PowerShell 5 is required](https://www.microsoft.com/en-us/download/details.aspx?id=50395).

PowerShell's version can be checked with the following command after opening PowerShell:

```
  PS C:\> $PSVersionTable.PSVersion
```

### **Default PowerShell version by Windows version**

* Windows 7   - PowerShell 2.0
* Windows 8   - PowerShell 3.0
* Windows 8.1 - PowerShell 4.0
* Windows 10  - PowerShell 5.0

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
* If running "vagrant up" with SYNC_REPO gets interrupted you need to supply 
SYNC_REPO again when running --provision. Otherwise the --provision run will clone
the community repo while mirroring the changes to the host and overwriting you local repo. 
* Windows users need to have the *vagrant-vbguest* in order to use this feature. If
the plugin is not present and SYNC_REPO is set, it will fail with an error.
* Windows users will need to specify the path in this way:

   ```
   export SYNC_REPO="c:\\Users\\Me\\kohaclone\\"
   ```
* UPDATE: Windows also supports paths with forward slash so it's possible to use:
   ```
   export SYNC_REPO="c:/Users/Me/kohaclone/"
   ```

### SMB

Value: 1

Usage:

```
  $ SMB=1 SYNC_REPO="/home/me/kohaclone" vagrant up
```

If you are running on Windows and you have administrative privileges on the computer
and you wish to make use of the SYNC_REPO functionality, enable the SMB variable in
order to use SYNC_REPO.

### SKIP_WEBINSTALLER

Value: 1

Usage:
```
  $ SKIP_WEBINSTALLER=1 vagrant up
```

This makes the provisioning script populate the DB with the sample data.

### CREATE_ADMIN_USER

Value: 1

Usage:
```
  $ CREATE_ADMIN_USER=1 vagrant up
```

This makes the provisioning script create a superlibrarian user, suitable for testing.

NOTE: The user is only created if SKIP_WEBINSTALLER was chosen too.

### KOHA_ELASTICSEARCH

Value: 1

Usage:

```
  $ KOHA_ELASTICSEARCH=1 vagrant up
```

This makes the provisioning scripts install Elasticsearch-related stuff, which is
still in heavy development. This is required for testing ES patches, and is not
enabled by default because it takes more time to complete and not everyone is interested yet.

The default is to install Elasticsearch 1.7, but development has moved towards Elasticsearch 2.4 
and 5.1 (the 2.x and 5.x branches, respectively). If you want to work on 2.x/5.x support, set
 _elasticsearch_version_ to _'2.x'_ or _'5.x'_ in your _vars/user.yml_ file.

NOTE: when choosing to install Elasticsearch, the *Vagrantfile* will create the VM using
4GB RAM. Make sure you have enough spare RAM and/or tweak the Vagrantfile as you need to.

### LOCAL_ANSIBLE

Value: 1

Usage:
```
  $ LOCAL_ANSIBLE=1 vagrant up
```

This makes the provisioning script run within the VM. For the task, it installs Ansible inside of
it before running the playbook. This is the default behaviour on Windows OS.

### PLUGIN_REPO

Value: The path to an existing Koha plugin repository/directory.

Usage:

```
  $ PLUGIN_REPO="/home/me/koha-plugin-dev-dir" vagrant up
```

You can use PLUGIN_REPO to have Vagrant mount your Koha plugin development directory within
KohaDevBox. This way you will have your working directory mounted on *{{ home_dir }}/koha_plugin*
which can be configured in */etc/koha/sites/kohadev/koha-conf.xml* so the dev instance points
to it (TODO: once bug 15879 is pushed, explain how to set multiple *koha_plugin_dir* entries).

### SYNC_KOHADOCS

Value: The path to an existing *kohadocs* repository clone.

Usage:

```
  $ SYNC_KOHADOCS="/home/me/kohadocs_clone" vagrant up
```

You can use SYNC_KOHADOCS to specify an external directory to be mounted instead of cloning the
*kohadocs* repository inside the box. The same as *SYNC_REPO*, but for kohadocs.

# Working on patches

When you are working on the code, you need to make sure you run each command on the right context.

Tasks that involve touching the code are run on the `vagrant` user, while instance specific ones
(like running db-dependent tests against the instance's DB) are run on the instance's user. We use
`k$` to denote we are on the instance's user.

On a packages environment, you need to use koha-shell to get the proper environment for
running tests.

## Get into the instance's user session

```
  $ sudo koha-shell kohadev
  k$
```

## Apply (and signing) patches from a bug

```
  $ cd kohaclone
  $ git bz apply -s <bug number>
```

## Update the DBIx schema files

```
  $ dbic
```

Note: this alias creates a whole new database in which it loads the kohastructure.sql file, it won't
touch your instance's DB.

## Run tests

```
  $ sudo koha-shell kohadev
  k$ cd kohaclone
  k$ prove t/<paste your favourite test>
```

## Run qa-test-tools

An alias is set up so that you can easily run Koha's qa-test-tools when you are
inside your Koha repository clone:

```
  $ sudo koha-shell kohadev
  k$ cd kohaclone
  k$ qa -c 7 -v 2
```


## Register with Bugzilla

Register with Bugzilla, Koha's bug tracker, if you have not done so already:

http://bugs.koha-community.org/bugzilla3/createaccount.cgi

You will need to put your username and password in vars/user.yml (see below), so
do not use a password you have used on other sites.


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

## Gotchas

### hosts.allow on Debian Jessie

Kohadevbox uses NFS to share the SYNC_REPO with the virtual machine.

On Debian Jessie, NFS exports seem to be tied down by default, and
this sharing won't work out of the box.  To make it work:
- edit '/etc/hosts.allow'
- add the virtualmachine's IP address (normally 192.168.50.10)
- stop the virtualmachine
- restart the "networking" service with
  `sudo service networking restart`
- restart the "nfs" services with
  `sudo service nfs-kernel-server restart`
- start the virtualmachine with the SYNC_REPO variable set
- nfs sharing, and the SYNC_REPO should now work

### Firewall may be blocking nfs export

To test this, turn off the firewall while setting up the devbox.

Don't forget to correctly configure your firewall after successful
testing.
