# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "server" do |config|
    config.vm.hostname = "chef-logstash-berkshelf"
    config.vm.box = "precise64"
    # config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"
    config.vm.network :private_network, ip: "192.168.33.13"
    config.berkshelf.enabled = true
    config.omnibus.chef_version = :latest
    config.vm.provision :chef_solo do |chef|
      chef.json = {
        :kibana => {
          :es_server => '127.0.0.1',
          :webserver_listen => '0.0.0.0',
          :webserver_port => 80,
          :webserver_aliases => []
        },
        :elasticsearch => {
          :cluster_name => 'logstash',
          'bootstrap.mlockall' => false
        },
        :mysql => {
          :server_root_password => 'rootpass',
          :server_debian_password => 'debpass',
          :server_repl_password => 'replpass'
        }
      }
      chef.run_list = ["recipe[apt::default]",
                       "recipe[logstash::test_server]"]
    end
  end

  config.vm.define "shipper" do |config|
    config.vm.hostname = "chef-logstash-berkshelf"
    config.vm.box = "precise64"
    # config.vm.box_url = "https://dl.dropbox.com/u/31081437/Berkshelf-CentOS-6.3-x86_64-minimal.box"
    config.vm.network :private_network, ip: "192.168.33.14"
    config.berkshelf.enabled = true
    config.omnibus.chef_version = :latest
    config.vm.provision :chef_solo do |chef|
      chef.json = {
        :mysql => {
          :server_root_password => 'rootpass',
          :server_debian_password => 'debpass',
          :server_repl_password => 'replpass'
        }
      }
      chef.run_list = ["recipe[apt::default]",
                       "recipe[logstash::test_shipper]",
                      "recipe[elasticsearch::default",
                      "recipe[kibana::default]",
                      "recipe[kibana::nginx]"]
    end
  end
end
