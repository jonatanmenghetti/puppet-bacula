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
  $storage_device_dir       = '/etc/bacula/bacula-sd.d',
  $storage_device_template  = 'bacula/storage/devices.conf.erb'
){


  concat::fragment {"device_${name}":
    target => "$storage_device_dir/device_${name}.conf",
    content => template($storage_device_template),
    tag => 'baculastorage',
    notify => Exec['breload'],
    order => 2
  }


}
