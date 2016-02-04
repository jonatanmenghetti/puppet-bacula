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

  $storage_conf = getparam(class['bacula::storage'],"storage_conf");
  $director = getparam(class['bacula::storage'],"director");
  $director_password = getparam(class['bacula::storage'],"director_password");
  $storage_name = getparam(class['bacula::storage'],"storage_name");
  $console_password = getparam(class['bacula::storage'],"console_password");
  $template = getparam(class['bacula::storage'],"template");
  $dir_storage_template = getparam(class['bacula::storage'],"dir_storage_template");
  $service_name = getparam(class['bacula::storage'],"service_name");
  $bacula_storage_dir = getparam(class['bacula::storage'],"bacula_storage_dir");
  $storage_address = getparam(class['bacula::storage'],"storage_address");
  $port = getparam(class['bacula::storage'],"port");
  $devices = getparam(class['bacula::storage'],"devices");
  $exporte = getparam(class['bacula::storage'],"exporte");

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
