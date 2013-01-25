# -*- mode: ruby -*-
# vi: set ft=ruby :

$hiera_data_path = './hieradata'
$hiera_config_file = 'hiera.yaml'
$guest_config_path = '/tmp/vagrant-hiera/config'
$guest_data_path = '/tmp/vagrant-hiera/data'

$data = {:user => 'vagrant', :group => 'vagrant'}

$hostsyaml = YAML::load_file($hiera_data_path + '/hosts.yaml')

common_yaml = {}
common_yaml['puppetheader'] = "managed by puppet"
common_yaml['hosts::site_hosts_hsh'] = {}
common_yaml['hosts::site_hosts_hsh']['ambari_hosts'] = []

$hostsyaml['hosts'].each do |h|
  # change the key name 'ambari_hosts' to one of your liking
  common_yaml['hosts::site_hosts_hsh']['ambari_hosts'] << "#{h['ip']}     #{h['name']} #{h['name'].split('.')[0]}"
end

# We use the 'hosts.yaml' file to create the 'common.yaml' file
File.open($hiera_data_path + "/common.yaml", "w") {|f| f.write(common_yaml.to_yaml) }
# We then use 'common.yaml' file through hiera+puppet through the puppet provisioner below,
# to populate the guests' /etc/hosts file

Vagrant::Config.run do |config|
  config.vm.box = "centos6X_x86_64"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.3-x86_64-v20130101.box"

  # config.vm.network :bridged, :bridge    => "br0"
  # config.vm.forward_port 80, 8080

  $hostsyaml['hosts'].each do |ho|
    config.vm.define ho['name'].split('.')[0] do |h|
      h.vm.box = "centos6X_x86_64"
      h.vm.network :hostonly, ho['ip']
      h.vm.host_name = "#{ho['name'].split('.')[0]}"
      if ho['memory']
        h.vm.customize ["modifyvm", :id, "--memory", ho['memory']]
      end
      h.vm.customize ["modifyvm", :id, "--usb", "off"]

      h.vm.share_folder('vagrant-hiera-config', $guest_config_path, './')
      h.vm.share_folder('vagrant-hiera-data', $guest_data_path, './hieradata')

      # The following is required, if you are on a office or other LAN with a DHCP server,
      # but want to use the "localdomain" domain name.
      # Or changing the VMs domain name from "localdomain" to your office domain may also work for you.
      h.vm.provision :shell, :inline => 'sudo mkdir -p /etc/puppet ; sudo sed -i -e "s/^search .*/search localdomain/" /etc/resolv.conf'

      h.vm.provision :shell, :inline => "sudo ln -fs #{$guest_config_path}/#{$hiera_config_file} /etc/hiera.yaml"
      h.vm.provision :shell, :inline => "sudo ln -fs #{$guest_config_path}/#{$hiera_config_file} /etc/puppet/hiera.yaml"

      h.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.manifest_file  = "centos6X_x86_64.pp"
        puppet.module_path    = "modules"
      end
    end
  end

end
