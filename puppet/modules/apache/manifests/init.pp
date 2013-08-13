# Class: apache
#
# This class installs Apache
#
# Parameters:
#
# Actions:
#   - Install Apache
#   - Manage Apache service
#
# Requires:
#
# Sample Usage:
#
class apache {
  include apache::params
  package { 'httpd':
    name   => $apache::params::apache_name,
    ensure => installed,
  }
  if ($::operatingsystem == 'Debian') {
  	package {
  	  apache2-mpm-worker:  ensure => present, notify => Service['httpd'];
  	  apache2-mpm-prefork: ensure => absent,  notify => Service['httpd'];
  	}
  }
  service { 'httpd':
    name      => $apache::params::apache_name,
    ensure    => running,
    enable    => true,
    subscribe => Package['httpd'],
  }

  # ASK: May want to purge all not realized modules using the resources resource type?
  define module($ensure = 'present') {
  	case $ensure {
  		'present': {
  			exec { "/usr/sbin/a2enmod $name":
  				unless => "/usr/bin/test -e /etc/apache2/mods-enabled/$name.load",
  				require => Package['httpd'],
  				notify => Service['httpd']
  			}
  		}
  		'absent': {
  			exec { "/usr/sbin/a2dismod $name":
  				onlyif => "/usr/bin/test -e /etc/apache2/mods-enabled/$name.load",
  				require => Package['httpd'],
  				notify => Service['httpd']
  			}
  		}
  	}
  }
  @module {
  	['rewrite', 'headers', 'expires', 'deflate', 'alias']: ensure => present;
  }

  file { $apache::params::vdir:
    ensure => directory,
    recurse => true,
    purge => true,
    require => Package['httpd'],
    notify => Service['httpd'],
  }
}
