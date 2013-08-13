class acquia::sass::preinstall {

  case $::operatingsystem {
    /(?i:debian|ubuntu)/: {
      class {'acquia::sass::apt':
        before => [ Class['acquia::sass::install'] ]
      }
    }
    default: {
      fail('Manage repos is enabled but this operating system not supported yet.')
    }
  }
}
