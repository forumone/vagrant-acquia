# Class: apache::ssl
#
# This class installs Apache SSL capabilities
#
# Parameters:
# - The $ssl_package name from the apache::params class
#
# Actions:
#   - Install Apache SSL capabilities
#
# Requires:
#
# Sample Usage:
#
class apache::ssl ($sni = true) {

  include apache

  case $operatingsystem {
     'centos', 'fedora', 'redhat', 'scientific': {
        package { $apache::params::ssl_package:
           require => Package['httpd'],
        }
     }
     'ubuntu', 'debian': {
        @apache::module { ssl: ensure => present }
        # SSL Server Name Indication (SNI)
        file { '/etc/apache2/conf.d/ssl-sni':
        	ensure  => $sni ? { true => file, false => absent },
        	owner   => 'root',
        	group   => 'root',
        	mode    => 0644,
        	content => template('apache/ssl-sni.conf.erb'),
        }
     }
  }
}
