class acquia::memcache {
  file { '/etc/sysconfig': 
    ensure => directory, 
  }
  
  class { 'memcached':
    port      => '11219',
    maxconn   => '8192',
    cachesize => '2048',  # 2GB
  }
}