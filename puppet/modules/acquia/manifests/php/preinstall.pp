class acquia::php::preinstall {

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      class {'acquia::php::apt':
        before => Class['acquia::php::install'],
      }
    }
    default: {
      fail('Manage repos is enabled but this operating system not supported yet.')
    }
  }
}
