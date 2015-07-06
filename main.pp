package {'php':
  ensure => present,
}

package {'mysql':
  ensure => present,
}

package {'php-mysql':
  ensure => present,
}
