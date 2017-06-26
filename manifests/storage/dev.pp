define bacula::storage::dev (
  $storage                  = undef,
  $mediatype                = 'File',
  $device                   = undef,
  $requiremount             = 'yes',
  $automount                = 'yes',
  $label                    = 'yes',
  $removable                = 'yes',
  $mountpoint               = undef,
  $mountcmmd                = '/bin/mount %m',
  $unmountcmmd              = '/bin/umount %m',
  $storage_device_dir       = '/etc/bacula/bacula-sd.d',
  $storage_device_template  = 'bacula/storage/devices.conf.erb',
){
  include stdlib

  if !$storage {
    $storage_name = getparam(Class['bacula::storage'],'storage_name')
  } else {
    $storage_name = $storage
  }

  $storage_conf = getparam(Class['bacula::storage'],'storage_conf')
  $director = getparam(Class['bacula::storage'],'director')
  $director_password = getparam(Class['bacula::storage'],'director_password')
  $console_password = getparam(Class['bacula::storage'],'console_password')
  $template = getparam(Class['bacula::storage'],'template')
  $dir_storage_template = getparam(Class['bacula::storage'],'dir_storage_template')
  $service_name = getparam(Class['bacula::storage'],'service_name')
  $bacula_storage_dir = getparam(Class['bacula::storage'],'bacula_storage_dir')
  $storage_address = getparam(Class['bacula::storage'],'storage_address')
  $port = getparam(Class['bacula::storage'],'port')
  $devices = getparam(Class['bacula::storage'],'devices')
  $exporte = getparam(Class['bacula::storage'],'exporte')
  $concurrent_jobs = getparam(Class['bacula::storage'],'concurrent_jobs')


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

  if !defined(File[$mountpoint]) {
    file {$mountpoint:
      ensure => directory,
      owner  => 'bacula',
      group  => 'bacula',
    }
  }
  if $exporte {
  # Create only device configuration

      if ! defined(Concat["${storage_name}_${name}"]) {
        @@concat {$storage_name:
          path  => "${bacula_storage_dir}/${storage_name}-${name}.conf",
          owner => 'bacula',
          group => 'bacula',
          mode  => '0644',
          tag   => 'baculastorage',
        }
      }

      @@concat::fragment {"stgdev_${storage_name}-${name}-header":
        target  => "${storage_name}_${name}",
        content => template('bacula/header.conf.erb'),
        tag     => 'baculastorage',
        order   => 0,
        notify  => Exec['breload'],
      }

    if ! $storage {

      @@concat::fragment {"stgdev_${storage_name}-${name}":
        target  => "${storage_name}_${name}",
        content => template($dir_storage_template),
        tag     => 'baculastorage',
        order   => 2,
        notify  => Exec['breload'],
      }
    }

    @@concat::fragment {"stgdev_${storage_name}-${name}-devices":
      target  => "${storage_name}_${name}",
      content => "Device = ${storage_name}:${name}\n",
      tag     => 'baculastorage',
      order   => 3,
      notify  => Exec['breload'],
    }
  }
}
