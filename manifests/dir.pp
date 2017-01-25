class bacula::dir (
  $conf_base_dir          = undef,
  $default_conf_dir       = undef,
  $bacula_clients_dir     = undef,
  $bacula_storages_dir    = undef,
  $manage_clients         = true,
  $manage_storages        = true,
) {

  $bacula_user = getparam(Class['bacula'],"user")
  $bacula_group = getparam(Class['bacula'],"group")

  file { ["${conf_base_dir}/${default_conf_dir}/${bacula_clients_dir}",
          "${conf_base_dir}/${default_conf_dir}/${bacula_storages_dir}"]:
    force   => true,
    recurse => true,
    ensure  => directory,
    owner   => $bacula_user,
    group   => $bacula_group,
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
