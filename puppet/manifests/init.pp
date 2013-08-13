node default {
  include apt
  
  package { ['git-core', 'nfs-common']: }
  
  class { "acquia": 
  	db_name    => 'gdpc',
  	db_user	   => 'gdpc',
  	db_pass    => 'gdpc'
  }
}