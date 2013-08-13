# Class: apache::php
#
# This class installs PHP for Apache
#
# Parameters:
# - $php_package
#
# Actions:
#   - Install Apache mod_php5 package
#
# Requires:
#
# Sample Usage:
#
class apache::php {
	include php
#  include apache::params

#  package { $apache::params::php_package:
#    ensure => present,
#  }
}
