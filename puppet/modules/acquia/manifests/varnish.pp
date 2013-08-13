class acquia::varnish (
	$listen=":80", 
	$cache_size="256m"
) {

  service { "varnish":
    ensure  => running,
    enable  => true,
  }

  package { "varnish":
    ensure  => installed,
    require => Exec ["resync_package_index"],
  }

  exec { "varnish-restart":
    command     => "/etc/init.d/varnish restart",
    refreshonly => true,
    require     => Package ["varnish"],
  }

  file { "/etc/default/varnish":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/varnish/etc_default.erb"),
    require => Package ["varnish"],
    before  => Service ["varnish"],
    notify  => Exec ["varnish-restart"],
  }
  
  file { "/etc/varnish/default.vcl":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/varnish/default.erb"),
    require => Package ["varnish"],
    before  => Service ["varnish"],
    notify  => Exec ["varnish-restart"],
  }
  
  file { "/etc/varnish/acl.vcl":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/varnish/acl.erb"),
    require => Package ["varnish"],
    before  => Service ["varnish"],
    notify  => Exec ["varnish-restart"],
  }

  file { "/etc/varnish/backends.vcl":
    ensure  => present,
    owner   => "root",
    group   => "root",
    mode    => "644",
    content => template("acquia/varnish/backends.erb"),
    require => Package ["varnish"],
    before  => Service ["varnish"],
    notify  => Exec ["varnish-restart"],
  }

  exec { "resync_package_index":
    command     => "/usr/bin/apt-get update",
    require     => File ["/etc/apt/sources.list.d/varnish.list"],
    refreshonly => true,
  }

  fetch_repo_key { "C4DEFFEB":
    ensure => present,
    keyid  => "C4DEFFEB",
    before => Exec ["resync_package_index"],
  }

  file { "/etc/apt/sources.list.d/varnish.list":
    ensure   => present,
    owner    => "root",
    group    => "root",
    mode     => "644",
    content  => "deb http://repo.varnish-cache.org/debian/ lucid varnish-3.0\n",
    notify   => Exec ["resync_package_index"],
  }
}

define fetch_repo_key ($keyid, $ensure, $keyserver = "subkeys.pgp.net") {
  case $ensure {
    present: {
      exec { "Import $keyid to apt keystore":
        path        => "/bin:/usr/bin",
        environment => "HOME=/root",
        command     => "gpg --keyserver $keyserver --recv-keys $keyid && gpg --export --armor $keyid | apt-key add -",
        user        => "root",
        group       => "root",
        unless      => "apt-key list | grep $keyid",
        logoutput   => on_failure,
      }
    }
    absent:  {
      exec { "Remove $keyid from apt keystore":
        path        => "/bin:/usr/bin",
        environment => "HOME=/root",
        command     => "apt-key del $keyid",
        user        => "root",
        group       => "root",
        onlyif      => "apt-key list | grep $keyid",
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for fetch_repo_key"
    }
  }
}