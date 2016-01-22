class bacula::dir (
  $bacula_clients_dir     = '/etc/bacula/conf.d/Clients',
  $manage_clients = true,
) {

  file { ['/etc/bacula/conf.d/Clients',
          '/etc/bacula/conf.d/Storages']:
    ensure => directory,
    owner => 'bacula',
    group => 'bacula',
  }

  if $manage_clients {
    File <<| tag == "baculaclient" |>>
  }

  exec {'breload':
    command => '/bin/echo "reload" | /sbin/bconsole',
    refreshonly => true,
  }
}
