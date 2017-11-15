# encoding: utf-8

require_relative 'version'


Vagrant.configure("2") do |config|
	
#  config.vm.synced_folder ".", "/vagrant", disabled: false
  (1..2).each do |i|
    config.vm.define "web#{i}" do |node|
        node.vm.box = "trusty64"
        node.vm.hostname = "web#{i}"
        node.vm.network :private_network, :ip => "172.32.22.#{i+1}"
        node.vm.network "forwarded_port", guest: 80, host: "808#{i}"
        node.vm.provider "virtualbox" do |vb|
          vb.memory = "2024"
        end	
	#	node.vm.provision "file" , source:"./shared", destination:"/opt/bitnami/apps/wordpress/htdocs/"
		
	 node.vm.provision "chef_zero" do |chef|
		chef.nodes_path = "cookbooks"
		chef.add_recipe "bitnami-wordpress"
		chef.json = {
		  "bitnami" => {
			"wordpress" => {
			  "version" => BITNAMI_WORDPRESS_VERSION
			}
		  }
		}
	  end
	end
  end

  # create load balancer
  config.vm.define :lb do |lb_config|
      lb_config.vm.box = "trusty64"
      lb_config.vm.hostname = "loadbalancer"
      lb_config.vm.network :private_network, :ip => "172.32.22.11"
      lb_config.vm.network "forwarded_port", guest: 80, host: 8080
      lb_config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
	  lb_config.vm.provision "update",type:"shell",path: "bootstrap2.sh"
      end   
  end
  # create mgmt node
  config.vm.define :mgmt do |mgmt_config|
      mgmt_config.vm.box = "trusty64"
      mgmt_config.vm.hostname = "mgmt"
      mgmt_config.vm.network :private_network, :ip => "172.32.22.1" 
      mgmt_config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
      end
      mgmt_config.vm.provision :shell, path: "bootstrap.sh"	  
  end

  # create some web servers
  # https://docs.vagrantup.com/v2/vagrantfile/tips.html

end
