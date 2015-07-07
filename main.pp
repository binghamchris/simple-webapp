include nginx

$www_root = '/var/www/default'
$index_file = 'index.php'

package {'php':
  ensure        => latest,
  allow_virtual => false,
}

package {'php-mysql':
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
  add_header  => {
    'X-Frame-Options'        => 'DENY',
    'X-XSS-Protection'       => '"1; mode=block"',
    'X-Content-Type-Options' => 'nosniff',
  },
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
  source  => '/opt/git/simple-webapp/index.php',
  require => File['www_root'],
}

class {'::mysql::server':
  root_password           => 'D2*rp*@qpvXOHJ7NQ*0lsZdvCF9IkE',
  remove_default_accounts => true,
  restart                 => true,
}

mysql::db { 'content':
  user     => 'webapp',
  password => 'vmJ0@DE4sH6NKp4%HD%shF7BJWSIvU',
  host     => 'localhost',
  grant    => ['SELECT'],
  sql      => '/opt/git/simple-webapp/content.sql',
}