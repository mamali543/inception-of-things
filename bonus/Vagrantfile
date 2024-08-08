Vagrant.configure("2") do |config|
    config.vm.define "mamali" do |control|
      control.vm.box = "bento/ubuntu-22.04"
      control.vm.hostname = "ooalien"
      control.vm.network "private_network", ip: "192.168.56.112"
      control.vm.network "forwarded_port", guest: 8080, host: 8080
      control.vm.network "forwarded_port", guest: 9090, host: 9090
      control.vm.network "forwarded_port", guest: 80, host: 80
      control.vm.network "forwarded_port", guest: 443, host: 443
      control.vm.provider "virtualbox" do |vb|
        vb.cpus = 8
        vb.memory = "6048"
      end
      control.vm.provision "shell", inline: "mkdir -p /vagrant/logs"
    
    # Provision setup.sh
      control.vm.provision "shell", path: "scripts/setup.sh"
    
    # Adding a delay to ensure setup.sh processes complete
      control.vm.provision "shell", inline: "sleep 10"
    
    # Provision install_gitlab.sh
      control.vm.provision "shell", path: "scripts/install_gitlab.sh"
    end
  end
  
