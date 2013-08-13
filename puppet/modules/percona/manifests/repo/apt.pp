# == Class: percona::repo::apt
#
class percona::repo::apt {

  if defined('apt::sources_list') {
    # Camp2Camp/apt module
    apt::key { 'CD2EFD2A':
      ensure => present,
      notify => Exec['percona::repo::apt-get update'],
    }
    
    apt::sources_list { 'percona':
      ensure  => present,
      source  => false,
      content => template ("${module_name}/repo/sources.list.erb"),
      notify  => Exec['percona::repo::apt-get update'],
      require => Apt::Key['CD2EFD2A'],
    }
  }

  if defined('apt::source') {
    # Puppetlabs/apt module
    apt::key { 'percona':
      ensure => present,
      key    => 'CD2EFD2A',
      notify => Exec['percona::repo::apt-get update'],
    }
    
    apt::source { 'percona':
      ensure      => present,
      include_src => true,
      location    => 'http://repo.percona.com/apt',
      release     => $::lsbdistcodename,
      repos       => 'main',
      notify      => Exec['percona::repo::apt-get update'],
      require     => Apt::Key['percona'],
    }
  }

  exec { 'percona::repo::apt-get update':
    command     => 'apt-get update',
    path        => '/usr/bin',
    refreshonly => true,
  }


}
