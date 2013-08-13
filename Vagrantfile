Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", :nfs => (RUBY_PLATFORM =~ /linux/ or RUBY_PLATFORM =~ /darwin/)
  config.vm.network :private_network, ip: "10.11.12.13"
end

Vagrant::Config.run do |config|

  config.vm.box = "lucid"

  config.vm.forward_port 80, 8080
  config.vm.forward_port 8080, 8081
  config.vm.forward_port 8983, 18983

  config.vm.provision :puppet do |puppet|
    puppet.options = "--verbose --debug"

    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file = "init.pp"
  end
end
