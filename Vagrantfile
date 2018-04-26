# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

VAGRANTFILE_ROOT = File.dirname(__FILE__)
VAGRANTFILE_ROOT_WIN = VAGRANTFILE_ROOT.gsub! "/", "\\"

module OS
  def OS.windows?
      (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
      (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.unix?
      !OS.windows?
  end

  def OS.linux?
      OS.unix? and not OS.mac?
  end
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "reverseproxy"
  config.vm.box = "centos/7"
  config.vm.network :private_network, ip: "10.3.1.99"

  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.synced_folder "./src/nginx/conf.d", "/etc/nginx/conf.d", type: "rsync"
  config.vm.synced_folder "./src/nginx/default.d", "/etc/nginx/default.d", type: "rsync"
  config.vm.synced_folder "./src/html", "/usr/share/nginx/html", type: "rsync"
  config.vm.synced_folder "./src/haproxy", "/etc/haproxy", type: "rsync"
  config.vm.synced_folder "./src/certs", "/etc/ssl/mycerts", type: "rsync"

  config.vm.provider "virtualbox" do |v|
    v.name = "reverseproxy"
    v.gui = false
    v.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :shell, :path => "shell-provisioner/install.sh"
  config.vm.provision :reload

  if OS.mac?
    
    config.trigger.after :up do
      `(vagrant rsync-auto &>/dev/null) &`
    end

    config.trigger.after :halt do
      `lsof -p $(ps ax | grep rsync-auto | grep -v grep | awk '{ print $1 }' | xargs echo | sed -e 's/ /,/g') | grep cwd | awk '$9=="ENVIRON["PWD"]" { print "Killing rsync-related PID: " $2 }; { system("kill " $2)}'`
    end

  elsif OS.windows?

    config.trigger.after :up, :append_to_path => VAGRANTFILE_ROOT do
      run "run_minimized 'cmd.exe' '/k vagrant rsync-auto'"
    end

    config.trigger.after :halt, :append_to_path => VAGRANTFILE_ROOT do
      run "kill_by_wd rsync-auto \"" + VAGRANTFILE_ROOT_WIN + "\""
    end

  end

end
