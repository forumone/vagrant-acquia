class acquia::sass::install {

  Package {
    require => [
      Class['acquia::sass::preinstall']
    ],
  }
  
  package { ['compass', 'singularitygs', 'breakpoint' ]:
    provider  => 'gem',
    ensure    => 'present',
  }
}