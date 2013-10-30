Vagrant.configure("2") do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "vagrant-f1-lucid"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "https://docs.google.com/a/forumone.com/uc?export=download&confirm=Gm5R&id=0B2EiybKZrZl7UjlKcHVjN2M0MGs"

  # Port for Varnish
  config.vm.network :forwarded_port, guest: 80, host: 8080
  
  # Port for direct access to Apache
  config.vm.network :forwarded_port, guest: 8080, host: 8081
  
  # Port for direct access to Solr
  config.vm.network :forwarded_port, guest: 8983, host: 18983
  
  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "10.11.12.13"

  # Add NFS only on linux or MacOS
  config.vm.synced_folder ".", "/vagrant", 
    :nfs => (RUBY_PLATFORM =~ /linux/ or RUBY_PLATFORM =~ /darwin/)

  # VirtualBox specific configuration  
  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    # Set NAT DNS host resolver to prevent issue with switching networks
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.ssh.forward_agent = true

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  config.vm.provision :puppet do |puppet|
    puppet.options = "--verbose --debug"
  
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file = "init.pp"
  end
end
