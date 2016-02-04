class bacula::dir (
  $bacula_clients_dir     = '/etc/bacula/conf.d/Clients',
  $manage_clients = true,
  $manage_storages = true,
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

  if $manage_storages {
    Concat <<|tag == "baculastorage" |>>
    Concat::Fragment <<|tag == "baculastorage" |>>
  }

  exec {'breload':
    command => '/bin/echo "reload" | /sbin/bconsole',
    refreshonly => true,
  }
}
