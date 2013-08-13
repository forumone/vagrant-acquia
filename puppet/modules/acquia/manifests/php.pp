class acquia::php {
  include acquia::php::preinstall
  include acquia::php::install
  
  Class['acquia::php::preinstall'] ->
  Class['acquia::php::install']
}

