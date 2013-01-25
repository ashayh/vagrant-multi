# need to have one host as the master...
node /^ambari-master.*/ {
  #include ambari
  include hosts

  #package { 'ambari-server':
  #  ensure  => installed,
  #  require => Yumrepo['ambari'],
  #}
  ## I thought this was needed, but ambari-setup will download
  ## jdk-6u31 for you.
  #file { "/var/lib/ambari-server/resources/jdk-6u31-linux-x64.bin":
  #  source => "puppet:///modules/ambari/jdk-6u31-linux-x64.bin",
  #  ensure => present,
  #  mode   => 755,
  #  owner  => root,
  #  group  => root,
  #}

}

node /^data.*/ {
  #include ambari
  include hosts
}

file { "/root/.ssh":
  ensure => directory,
} ->

file { "/root/.ssh/id_rsa":
  source => "puppet:///modules/ambari/ssh/id_rsa",
  mode => 600,
  owner => root,
  group => root,
 } ->

file { "/root/.ssh/id_rsa.pub":
  source => "puppet:///modules/ambari/ssh/id_rsa.pub",
  mode => 644,
  owner => root,
  group => root,
} ->

ssh_authorized_key { "ssh_key":
  ensure => "present",
  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCyAjGa/D1QcejBWnGgJGndnZrOFMgrQSYTlM5K97hsz+h27Wz9qNyZXW9nc2SIqD4dNJVZ7SEnM6Z5bUjXUcQcB4bhQwFxBDqgP5UbPb0PWbJyY/xIFUJBfMA176gmDyHxUmp8U4FUQ55nW27w7+pLEIUUVaObqbKS8IWx81q/x2xEoZwaTBUAVh99kF4LVs6enSYSjls4r8Lc/QyQGbBxd92d8LNvLh2CXXPKNp1p+5g+MI6syqFO8N6qcuQuSWAFr/M5qiFuiCKFG/Ec7dapd/6f0wvcNKYH14SsWdkxKwpWBqf+jIqK3TgPAsq9Kyo49uh3KfBNC6fAl+79Me99',
  type   => "ssh-rsa",
  user   => "root",
} ->

file { "/root/.ssh/config":
  source => "puppet:///modules/ambari/ssh/config",
  mode => 644,
  owner => root,
  group => root,
}

$packages = ['vim-enhanced']

package { $packages:
  ensure => "latest",
}

$services = ['auditd', 'fcoe', 'ip6tables', 'iptables', 'iscsi', 'iscsid', 'lldpad', 'netfs', 'rpcbind', 'rpcgssd', 'rpcidmapd', 'rpcsvcgssd']

service { $services:
  ensure => stopped,
  enable => false,
}
