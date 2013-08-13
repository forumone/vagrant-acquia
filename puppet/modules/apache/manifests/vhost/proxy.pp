# Define: apache::vhost::proxy
#
# Configures an apache vhost that will only proxy requests
#
# Parameters:
# * $port:
#     The port on which the vhost will respond
# * $path:
#     Path that the requests will be proxied for, defaults to '/'
# * $dest:
#     URI that the requests will be proxied for
# - $priority
# - $template -- the template to use for the vhost
# - $vhost_name - the name to use for the vhost, defaults to '*'
#
# Actions:
# * Install Apache Virtual Host
#
# Requires:
# Apache::Module['proxy']
# Sample Usage:
# @apache::module { proxy: ensure => present }
#
define apache::vhost::proxy (
    $port          = 80,
    $path          = '/',
    $dest,
    $priority      = '10',
    $template      = "apache/vhost-proxy.conf.erb",
    $serveradmin   = '',
    $serveraliases = '',
    $ssl           = false,
    $vhost_name    = '*',
    $ensure        = 'present'
  ) {

  include apache
  $apache_name = $apache::params::apache_name

  $srvname = $name

  if $ssl == true {
    include apache::ssl
  }

  file {"${apache::params::vdir}/${priority}-${name}":
    ensure  => $ensure,
    content => template($template),
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    require => Package['httpd'],
    notify  => Service['httpd'],
  }


}
