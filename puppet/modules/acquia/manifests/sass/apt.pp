class acquia::sass::apt {
  if defined('apt::source') {
    # Puppetlabs/apt module
    apt::ppa { 'ppa:voronov84/ruby': 
      notify    => Exec['acquia::sass::apt-get update'],
    }
    
    apt::force { 'rubygems':
      version   => '1.3.7-0ubuntu1~lucid2',
      require   => Apt::Ppa['ppa:voronov84/ruby'],
    }
  }

  exec { 'acquia::sass::apt-get update':
    command     => 'apt-get update',
    path        => '/usr/bin',
    refreshonly => true,
  }
}
