class acquia::solr(
  $version      = '3.6.2'
) {
  #install the java package.
  package { ["openjdk-6-jre-headless"]:
    ensure  => installed,
  }
  
  #Download apache solr
  exec{"acquia::solr::download":
    command => "wget --directory-prefix=/opt http://archive.apache.org/dist/lucene/solr/${version}/apache-solr-${version}.tgz",
    path => '/usr/bin',
    require => Package ["openjdk-6-jre-headless"],
    creates => "/opt/apache-solr-${version}.tgz"
  }
  
  #extract from the solr archive 
  exec{"acquia::solr::extract":
    command => "tar -zxvf /opt/apache-solr-${version}.tgz -C /opt",
    path => ["/bin"],
    require => [ Exec["acquia::solr::download"] ], 
    creates => "/opt/apache-solr-${version}/LICENSE.txt", 
  }
  
  file { "/etc/default/jetty":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/etc_default.erb"),
    require => Exec ["acquia::solr::extract"],
  }
  
  file { "/etc/init.d/solr":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "755",
    content => template("acquia/solr/solr.erb"),
    require => Exec ["acquia::solr::extract"],
  }
  
  service { 'solr':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  } 
  
  file { '/var/log/solr': 
    ensure    => 'directory',
    owner     => 'root',
    group     => 'root',
  }
  
  file { "/opt/apache-solr-${version}/example/solr/conf/protwords.txt":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/conf/3.x/protwords.erb"),
    require => Exec ["acquia::solr::extract"],
    notify  => Service['solr']
  }
  
  file { "/opt/apache-solr-${version}/example/solr/conf/schema_extra_fields.xml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/conf/3.x/schema_extra_fields.erb"),
    require => Exec ["acquia::solr::extract"],
    notify  => Service['solr']
  }
  
  file { "/opt/apache-solr-${version}/example/solr/conf/schema_extra_types.xml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/conf/3.x/schema_extra_types.erb"),
    require => Exec ["acquia::solr::extract"],
    notify  => Service['solr']
  }
  
  file { "/opt/apache-solr-${version}/example/solr/conf/schema.xml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/conf/3.x/schema.erb"),
    require => Exec ["acquia::solr::extract"],
    notify  => Service['solr']
  }
  
  file { "/opt/apache-solr-${version}/example/solr/conf/solrconfig_extra.xml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/conf/3.x/solrconfig_extra.erb"),
    require => Exec ["acquia::solr::extract"],
    notify  => Service['solr']
  }
  
  file { "/opt/apache-solr-${version}/example/solr/conf/solrconfig.xml":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/conf/3.x/solrconfig.erb"),
    require => Exec ["acquia::solr::extract"],
    notify  => Service['solr']
  }
  
  file { "/opt/apache-solr-${version}/example/solr/conf/solrcore.properties":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/solr/conf/3.x/solrcore_properties.erb"),
    require => Exec ["acquia::solr::extract"],
    notify  => Service['solr']
  }
}