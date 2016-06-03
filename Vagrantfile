# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.define "builder" do |builder|
    builder.vm.box = "ubuntu/trusty64"
    builder.vm.hostname = "builder"

    builder.vm.provider "virtualbox" do |vb|
      # Use 2 GB and 2 CPUs for the build environment
      vb.memory = 2048
      vb.cpus = 2
    end
  end

  # The first provisioner creates the development environment, the second builds
  # OpenWrt and shuts down the machine. Use the "--provision-with devenv" option
  # with your Vagrant command (up, provision or reload) to skip the build step.

  config.vm.provision "devenv", type: "shell", privileged: false, path: "devenv.sh"
  config.vm.provision "build", type: "shell", privileged: false, path: "build.sh"

end
