include nginx

$www_root ='/var/www/default'

package {'php':
  ensure        => present,
  allow_virtual => false,
}

package {'php-fpm':
  ensure        => present,
  allow_virtual => false,
}

service {'php-fpm':
  ensure    => running,
  enable    => true,
  require   => Package['php-fpm'],
}

nginx::resource::vhost { 'default':
  ensure      => present,
  listen_port => 80,
  index_files => ['index.php'],
  www_root    => $www_root,
  server_name => ['_'],
  require     => File ['www_root', 'index.php'],
}

nginx::resource::location { 'default_root':
  ensure              => present,
  vhost               => 'default',
  location            => '~ \.php$',
  www_root            => $www_root,
  fastcgi             => '127.0.0.1:9000',
  index_files         => ['index.php'],
  fastcgi_script      => undef,
  location_cfg_append => {
    fastcgi_connect_timeout => '3m',
    fastcgi_read_timeout    => '3m',
    fastcgi_send_timeout    => '3m'
  }
}

file {'www_root':
  path    => $www_root,
  ensure  => directory,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
}

file {'index.php':
  path    => "${www_root}/index.php",
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0755',
  content => '<?php echo "Hello AWS!"; ?>',
  require => File ['www_root'],
}