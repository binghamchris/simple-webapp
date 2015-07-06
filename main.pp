include nginx

$www_root = '/var/www/default'
$index_file = 'index.php'

package {'php':
  ensure        => latest,
  allow_virtual => false,
}

package {'php-fpm':
  ensure        => latest,
  allow_virtual => false,
  require       => Package['php'],
}

service {'php-fpm':
  ensure  => running,
  enable  => true,
  require => Package['php-fpm'],
}

nginx::resource::vhost { 'default':
  ensure      => present,
  listen_port => 80,
  index_files => ["${index_file}"],
  www_root    => $www_root,
  server_name => ['_'],
  require     => File['www_root', 'index_file'],
}

nginx::resource::location { 'default_root':
  ensure      => present,
  vhost       => 'default',
  location    => '~ \.php$',
  www_root    => $www_root,
  fastcgi     => '127.0.0.1:9000',
  index_files => ["${index_file}"],
}

file {'www_root':
  path   => $www_root,
  ensure => directory,
  owner  => 'root',
  group  => 'root',
  mode   => '0755',
}

file {'index_file':
  path    => "${www_root}/${index_file}",
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => '<?php echo "Hello AWS!"; ?>',
  require => File['www_root'],
}