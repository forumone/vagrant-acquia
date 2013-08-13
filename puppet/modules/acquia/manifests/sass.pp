class acquia::sass {
  include acquia::sass::preinstall
  include acquia::sass::install
  
  Class['acquia::sass::preinstall'] ->
  Class['acquia::sass::install']
}