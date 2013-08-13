define acquia::database(
	$username		= 'drupal',
	$password		= 'drupal'
) {
  
  class { 'percona':
    server          => true,
    percona_version => '5.5',
    manage_repo     => true
  }
  
  percona::conf {
    'innodb_file_per_table': content => "[mysqld]\ninnodb_file_per_table";
    'query_cache_size':      content => "[mysqld]\nquery_cache_size = 32M";
    'table_open_cache':      content => "[mysqld]\ntable_open_cache = 768";
    'table_cache':           content => "[mysqld]\ntable_cache = 768";
    'memory_buffers':        content => "[mysqld]\ntmp_table_size = 512M\nmax_heap_table_size = 128M\njoin_buffer_size = 128M\nmyisam_sort_buffer_size = 512M";
  }
  
  percona::database { $name:
    ensure          => present,
  }
  
  percona::rights {"${username}@localhost/${name}":
    priv            => 'all',
    user			=> $username,
    database		=> $name,
    password        => $password,
    notify          => Exec['acquia::php::restart'],
  }
}