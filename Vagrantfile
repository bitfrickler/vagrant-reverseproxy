# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.vm.hostname = "reverseproxy"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos/7"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  #config.vm.network :forwarded_port, guest: 3030, host: 3030

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "10.3.1.12"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  #config.vm.network :public_network

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.synced_folder "./src/nginx", "/etc/nginx", type: "rsync"
  config.vm.synced_folder "./src/haproxy", "/etc/haproxy", type: "rsync"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider "virtualbox" do |v|
    v.name = "reverseproxy"
    v.gui = false
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :shell, :path => "shell-provisioner/install.sh"
  #config.vm.provision :shell, :path => "shell-provisioner/install_go.sh", privileged: false

  config.vm.provision :reload

  config.trigger.after :up do
    `(vagrant rsync-auto &>/dev/null) &`
  end

  config.trigger.after :halt do
     `lsof -p $(ps ax | grep rsync-auto | grep -v grep | awk '{ print $1 }' | xargs echo | sed -e 's/ /,/g') | grep cwd | awk '$9=="ENVIRON["PWD"]" { print "Killing rsync-related PID: " $2 }; { system("kill " $2)}'`
  end

end
