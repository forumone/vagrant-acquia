class acquia::php::install(
  $template       = "acquia/www-conf.erb",
  $socket         = "/var/run/php-fpm.sock"
) {
  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      $packages = ['php5-cgi', 'php5-fpm', 'php5-gd', 'php5-mysql', 'php-apc', 'php5-memcache', 'php5-curl', 'php5-common', 'php5-cli']
    }

    default: {
      fail('Operating system not supported yet.')
    }
  }

  Package {
    require => [
      Class['acquia::php::preinstall']
    ],
  }

  package { $packages:
    ensure  => 'present',
    notify  => Exec['acquia::php::restart']
  }
  
  file {"/etc/php5/fpm/pool.d/www.conf":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Package['php5-fpm'],
    notify  => Exec['acquia::php::restart']
  }
  
  file {"/etc/php5/cli/php.ini":
    content => template("acquia/php/cli.erb"),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Package['php5-cli'],
  }
}

