class ambari {

  # name has to be 'ambari'
  yumrepo { 'ambari':
    descr    => 'Ambari 1.X repository',
    baseurl  => 'http://public-repo-1.hortonworks.com/AMBARI-1.x/repos/centos6',
    gpgkey   => 'http://public-repo-1.hortonworks.com/AMBARI-1.x/repos/centos6/RPM-GPG-KEY/RPM-GPG-KEY-Jenkins',
    gpgcheck => '1',
    enabled  => '1',
    priority => '1',
  }
}
