# Define: apache::vhost::fastcgi_php_proxy
#
# This class will create a vhost that connects to PHP app server via FastCGI
#
# Parameters:
# * $docroot:           Provides the `DocumentRoot` variable
# * $port:              Which port to listen on
# * $fastcgi_dir:       FastCGI directory, this is usually:
#                    home/${user}/fastcgi-bin
# * $proxy_path:        Path that the requests will be proxied for
# * $proxy_dest:        URI that the requests will be proxied for
# * $socket:            Socket file, usually: /var/run/php-${user}.sock
# * $options:           Apache Options directive, e.g. 'All'
# * $allow_override:    Apache AllowOverride directive, default is 'All'
# - $vhost_name:        the name to use for the vhost, defaults to '*'
#
# Actions:
#   Installs apache and creates a FastCGI PHP vhost
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::fastcgi_php_proxy (
  $docroot,
  $port           = 80,
  $fastcgi_dir,
  $socket         = undef,
  $proxy_path,
  $proxy_dest,
  $priority       = '10',
  $serveraliases  = '',
  $serveradmin    = '',
  $template       = "apache/vhost-fastcgi-php-proxy.conf.erb",
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
