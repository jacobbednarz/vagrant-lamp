# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'trusty64'

  # Forward ports to Apache and MySQL.
  config.vm.network 'forwarded_port', guest: 80, host: 8888
  config.vm.network 'forwarded_port', guest: 3306, host: 8889

  config.vm.synced_folder 'htdocs', '/var/www/html',
    owner: "vagrant",
    group: "www-data",
    mount_options: ["dmode=775,fmode=664"]
  config.vm.provision 'shell', path: 'provision.sh'
end
