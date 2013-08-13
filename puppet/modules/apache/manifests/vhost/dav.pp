# Define: apache::vhost::dav
#
# This class will create a vhost that servers a WebDAV repository server.
#
# Parameters:
# * $docroot: Provides the `DocumentRoot` variable
# * $port:    Which port to listen on
# * $options: Apache Options directive, e.g. 'All'
# * $allow_override: Apache AllowOverride directive, default is 'All'
# - $vhost_name
#
# Actions:
#   Installs apache and creates a WebDAV vhost
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::dav (
  $docroot,
  $port           = 80,
  $priority       = '10',
  $serveraliases  = '',
  $serveradmin    = '',
  $template       = "apache/vhost-dav.conf.erb",
  $options        = '+Indexes', # DAV is usually publicly listable, unless you use it for normal hosting
  $allow_override = 'None',
  $allow_from     = 'localhost', # By default it is "secure" because we don't put any security yet
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
