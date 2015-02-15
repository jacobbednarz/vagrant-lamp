# Vagrant LAMP

### Requirements

- VirtualBox <http://www.virtualbox.com>
- Vagrant <http://www.vagrantup.com>
- Git <http://git-scm.com/>

### Usage

```
$ git clone git@github.com:jacobbednarz/vagrant-lamp.git 
$ cd vagrant-lamp 
$ vagrant up
````

That is pretty simple.

### Connecting

Apache: The Apache server is available at http://localhost:8888

MySQL: Externally the MySQL server is available at port 8889, and when running on
the VM it is available as a socket or at port 3306 as usual.  

Username: root
Password: root

### Technical Details

- Ubuntu 14.04 64-bit
- Apache 2
- PHP 5.5
- MySQL 5.5

The web root is located in the project directory at `htdocs` and you can install
your files there

Accessing the box is as straight forward as `vagrant ssh`.
