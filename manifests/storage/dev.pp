define bacula::storage::dev (
  $name                     = undef,
  $type                     = 'File',
  $device                   = undef,
  $requiremount             = 'yes',
  $automount                = 'yes',
  $label                    = 'yes',
  $removable                = "yes",
  $mountpoint               = undef,
  $mountcmmd                = "/bin/mount %m",
  $unmountcmmd              = "/bin/umount %m",
  $storage_device_dir       = '/etc/bacula/bacula-sd.d/',
  $storage_device_template  = 'bacula/storage/devices.conf.erb'
){
  include stdlib

  $storage_conf = getparam(Class['bacula::storage'],"storage_conf")
  $director = getparam(Class['bacula::storage'],"director")
  $director_password = getparam(Class['bacula::storage'],"director_password")
  $storage_name = getparam(Class['bacula::storage'],"storage_name")
  $console_password = getparam(Class['bacula::storage'],"console_password")
  $template = getparam(class['bacula::storage'],"template")
  $dir_storage_template = getparam(Class['bacula::storage'],"dir_storage_template")
  $service_name = getparam(Class['bacula::storage'],"service_name")
  $bacula_storage_dir = getparam(Class['bacula::storage'],"bacula_storage_dir")
  $storage_address = getparam(Class['bacula::storage'],"storage_address")
  $port = getparam(Class['bacula::storage'],"port")
  $devices = getparam(Class['bacula::storage'],"devices")
  $exporte = getparam(Class['bacula::storage'],"exporte")

  concat { "${storage_device_dir}/device_${name}.conf":
    owner => 'bacula',
    group => 'bacula',
    mode  => '0644'
  }

  concat::fragment { "dev_${name}":
    target => "$storage_device_dir/device_${name}.conf",
    content => template($storage_device_template),
    order => 1,
    notify => Service['bacula-sd'],
  }

  if $exporte {
    @@concat::fragment {"stgdev_${storage_name}":
      target => "$bacula_storage_dir/$storage_name.conf",
      content => template($dir_storage_template),
      tag => 'baculastorage',
      order => 2,
      notify => Exec['breload'],
    }
  }
}
