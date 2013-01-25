# == Class: hosts
#
# Manage the /etc/hosts file with the hiera data store.  Allows for a list of 
#  site-wide hosts as well as node-specific list of host entries.
#
# === Usage
#
#  @see README
#
# === Authors
#
# Jose Guevarra <jguevarra@lsit.ucsb.edu>
#
# === Copyright
#
# Copyright 2012 UC Regents, Distributed under the New BSD License
#
class hosts {

  # Get host entries from hiera
  $puppetheader = hiera('puppetheader', 'Managed by Puppet')
  
  $node_hosts_hsh = hiera('hosts::node_hosts_hsh', {})
  $site_hosts_hsh = hiera('hosts::site_hosts_hsh', {})
  
  file { "hosts_file" :
    ensure  => 'present',
    path    => hiera('hosts::hosts_path', '/etc/hosts'),
    content => template(hiera('hosts::hosts_tmpl', 'hosts/hosts.erb')),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

}
