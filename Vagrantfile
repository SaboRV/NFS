# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|


 config.vm.define "nfss" do |nfss| 
 nfss.vm.box = "gusztavvargadr/ubuntu-server-2204-lts"
 nfss.vm.box_version = "2204.0.2312"
 nfss.vm.network "private_network", ip: "192.168.56.20",  virtualbox__intnet: "net1" 
 nfss.vm.hostname = "nfss" 
 nfss.vm.provision "shell", path: "nfss_script.sh"
 nfss.vm.provider :virtualbox do |vb|
      vb.name = "nfss"
      vb.memory = 4096
      vb.cpus = 4
    end
 end 
 config.vm.define "nfsc" do |nfsc| 
 nfsc.vm.box = "ubuntu/focal64"
 nfsc.vm.network "private_network", ip: "192.168.56.21",  virtualbox__intnet: "net1" 
 nfsc.vm.hostname = "nfsc"
 nfsc.vm.provision "shell", path: "nfsc_script.sh"
 nfsc.vm.provider :virtualbox do |vb|
      vb.name = "nfsc"
      vb.memory = 2048 
      vb.cpus = 2 
    end
 end 
end 
