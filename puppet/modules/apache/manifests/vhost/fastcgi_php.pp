# Define: apache::vhost::fastcgi_php5
#
# This class will create a vhost that connects to PHP app server via FastCGI
#
# Parameters:
# * $docroot: Provides the `DocumentRoot` variable
# * $port:    Which port to listen on
# * $fastcgi_dir: FastCGI directory, this is usually:
#              home/${user}/fastcgi-bin
# * $socket:  Socket file, usually: /var/run/php-${user}.sock
# * $options: Apache Options directive, e.g. 'All'
# * $allow_override: Apache AllowOverride directive, default is 'All'
# - $vhost_name
#
# Actions:
#   Installs apache and creates a FastCGI PHP vhost
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::fastcgi_php (
  $docroot,
  $port           = 80,
  $fastcgi_dir,
  $socket         = undef,
  $priority       = '10',
  $serveraliases  = '',
  $serveradmin    = '',
  $template       = "apache/vhost-fastcgi-php.conf.erb",
  $options        = $apache::params::options,
  $allow_override = 'All',
  $apache_name    = $apache::params::apache_name,
  $vhost_name     = $apache::params::vhost_name,
  $ssl_cert       = '',    # SSL Certificate
  $ssl_key        = '',    # SSL Private Key
  $ssl_chain      = '',    # SSL Certificate Chain
  $ssl_ca         = ''     # SSL CA Certificate
) {

  include apache

  $srvname = $name

  file {"${apache::params::vdir}/${priority}-${name}":
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Package['httpd'],
    notify  => Service['httpd'],
  }

#  TODO: Firewall
#  if ! defined(Firewall["0100-INPUT ACCEPT $port"]) {
#    @firewall {
#      "0100-INPUT ACCEPT $port":
#        jump  => 'ACCEPT',
#        dport => "$port",
#        proto => 'tcp'
#    }
#  }

}
