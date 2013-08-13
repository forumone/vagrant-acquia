class acquia::web(
	$port = 80
) {
  include apache
  
  package { libapache2-mod-fastcgi: 
  	ensure => present
  }
  
  # Enable other needed modules
  @apache::module { actions:    
  	ensure => present;
    
    fastcgi:
    require => Package['libapache2-mod-fastcgi'],
    ensure => present;
  }
  
  apache::vhost { 'localhost':
    serveradmin   => 'admin@localhost',
    docroot       => '/vagrant/docroot',
  }
  
  # Realize previously defined virtual resources of Apache modules
  Apache::Module <| |>
  
  #file { "/vagrant/docroot":
  #  ensure => directory,
  #  owner  => 'vagrant',
  #  group  => 'vagrant',
  #  mode   => 0755
  #}
  file { "/var/www":
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => 0755
  }
  
  file { "/var/www/fastcgi-bin":
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => 0755
  }
  
  file { "/etc/apache2/ports.conf":
  	ensure => present,
  	owner  => 'root',
  	group  => 'root',
  	mode   => '644',
  	content => template('acquia/ports.erb'),
  	notify  => Service['httpd'],
  	require => Package['httpd'] 
  }
  
  apache::vhost::fastcgi_php { "www-data.${::fqdn}":
    docroot         => "/vagrant/docroot",
    port			=> 8080,
    serveraliases   => [ 'localhost' ],
    fastcgi_dir     => '/var/www',
    template        => "acquia/vhost-fastcgi-php.conf.erb",
    socket          => "/var/run/php-fpm.sock",
    allow_override  => 'All',
  }
}
