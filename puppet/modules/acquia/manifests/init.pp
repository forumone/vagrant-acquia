class acquia (
  $db_name      = 'drupal',
  $db_user      = 'drupal',
  $db_pass      = 'drupal'
) {
  
  class { 'acquia::ubuntu': }
  
  class { "acquia::php": 
  	require     => [ Service['httpd'], Class['percona'] ]
  }
  
  class { "acquia::web": 
    port        => '8080',
    notify      => Service['php5-fpm']
  }
  
  class { "acquia::memcache": }
  
  acquia::database { $db_name: 
  	username	=> $db_user,
  	password	=> $db_pass,
  	notify      => [ Service['httpd'], Service['php5-fpm'] ]
  }
  
  service { "php5-fpm":
    ensure    => running,
    enable    => true,
    require   => Package['php5-fpm'],
    subscribe => Package['php5-fpm']
  }
  
  class { 'acquia::drush': }
  
  exec { 'acquia::php::restart':
    command     => 'service php5-fpm restart',
    path        => '/usr/sbin',
    require     => [ Class['acquia::web'], Class['acquia::php'], Class['percona'] ],
    refreshonly => true,
    returns     => 2,
  }
  
  class { 'acquia::varnish': }
  
  class { "acquia::solr": }

  class { 'acquia::sass': }
}
