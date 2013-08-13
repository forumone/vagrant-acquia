# Define: apache::vhost::redirect
#
# This class will create a vhost that does nothing more than redirect to a given location
#
# Parameters:
#   $port:
#       Which port to list on
#   $dest:
#       Where to redirect to
# - $vhost_name
#
# Actions:
#   Installs apache and creates a vhost
#
# Requires:
#
# Sample Usage:
#
define apache::vhost::redirect (
    $port          = 80,
    $dest,
    $priority      = '10',
    $serveraliases = '',
    $serveradmin   = '',
    $template      = "apache/vhost-redirect.conf.erb",
    $vhost_name    = '*',
    $status        = 'temporary'
) {

  include apache

  $srvname = $name
  $status_code = $status ? {
  	temporary => '302',
  	permanent => '301'
  }

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

