class bacula::dir (
  $manage_clients = true,
) {

  if $manage_clients {
    File <<| tag == "baculaclient" |>>
  }

  exec {'breload':
    command => '/bin/echo "reload" | /sbin/bconsole',
    refreshonly => true,
  }
}
