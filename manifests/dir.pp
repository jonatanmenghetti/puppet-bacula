class bacula::dir (
  $bacula_clients_dir     = '/etc/bacula/conf.d/Clients',
  $manage_clients = true,
) {

  if $manage_clients {
    concat <<| tag == "baculaclient" |>>
    concat::fragment <<| tag == "baculaclient" |>>
  }

  exec {'breload':
    command => '/bin/echo "reload" | /sbin/bconsole',
    refreshonly => true,
  }
}
