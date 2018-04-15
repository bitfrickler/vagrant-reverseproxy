# vagrant-reverseproxy

This is a playground for me to fiddle around with reverse proxy software (currently nginx and haproxy).
Based on CentOS 7 and tested with vagrant 2.0.3 under macOS. The Vagrantfile uses rsync-based shared folders.

You will need additional plugins for Vagrant:

    vagrant plugin install vagrant-triggers vagrant-reload
