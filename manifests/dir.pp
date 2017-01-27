class bacula::dir (
  $dir_password,
  $manage_clients         = undef,
  $manage_storages        = undef,
  $package_name           = undef,
  $port                   = undef,
  $query_file             = undef,
  $pid_directory          = undef,
  $concurrent_jobs        = undef,
  $message                = undef,
  $service_name           = undef,
  $config_file            = undef,
  $config_template        = undef,
  $job_defs_file          = undef,
) {

  include stdlib

  if !(defined(Class['bacula'])) {
    fail('You must include the bacula base class before using any bacula defined resources')
  }

  $bacula_user          = getparam(Class['bacula'],'user')
  $bacula_group         = getparam(Class['bacula'],'group')
  $conf_base_dir        = getparam(Class['bacula'],'conf_base_dir')
  $_default_conf_dir    = getparam(Class['bacula'],'default_conf_dir')
  $_bacula_clients_dir  = getparam(Class['bacula'],'bacula_clients_dir')
  $_bacula_storages_dir = getparam(Class['bacula'],'bacula_storages_dir')
  $_bacula_schedule_dir = getparam(Class['bacula'],'bacula_schedule_dir')
  $_bacula_filesets_dir = getparam(Class['bacula'],'bacula_filesets_dir')
  $working_directory    = getparam(Class['bacula'],'working_directory')

  $default_conf_dir     = "${conf_base_dir}/${_default_conf_dir}"
  $bacula_clients_dir   = "${default_conf_dir}/${_bacula_clients_dir}"
  $bacula_storages_dir  = "${default_conf_dir}/${_bacula_storages_dir}"
  $bacula_schedule_dir  = "${default_conf_dir}/${_bacula_schedule_dir}"
  $bacula_filesets_dir  = "${default_conf_dir}/${_bacula_filesets_dir}"
  $dir_config_file      = "${conf_base_dir}/${config_file}"

  package { $package_name:
    ensure => installed,
  }
  
  file { [$default_conf_dir,
          $bacula_clients_dir,
          $bacula_storages_dir,
          $bacula_schedule_dir,
          $bacula_filesets_dir]:
    ensure  => directory,
    recurse => true,
    owner   => $bacula_user,
    group   => $bacula_group,
  }->
  file { $dir_config_file:
    ensure  => file,
    content => template($config_template),
    notify  => Service[$service_name],
    require => Package[$package_name],
  }->
  service { $service_name:
    ensure => running,
    enable => true,
  }


  if str2bool($manage_clients) {
    File <<| tag == 'baculaclient' |>>
  }

  if str2bool($manage_storages) {
    Concat <<|tag == 'baculastorage' |>>
    Concat::Fragment <<|tag == 'baculastorage' |>>
  }

  concat { "${default_conf_dir}/Catalogs.conf":
    ensure => present
  }

  concat::fragment {"Catalogs.conf-header":
    target  => "${default_conf_dir}/Catalogs.conf",
    content => template('bacula/header.conf.erb'),
    order   => '0'
  }

  concat { "${default_conf_dir}/JobDefs.conf":
    ensure => present
  }

  concat::fragment {"JobDefs.conf-header":
    target  => "${default_conf_dir}/JobDefs.conf",
    content => template('bacula/header.conf.erb'),
    order   => '0'
  }

  concat { 'PoolsResource':
    path   => "${default_conf_dir}/Pools.conf",
    ensure => present,
    owner  => $bacula_user,
    group  => $bacula_group,
  }

  concat::fragment {"Pools.conf-header":
    target  => 'PoolsResource',
    content => template('bacula/header.conf.erb'),
    order   => '0'
  }

  concat { "${default_conf_dir}/Messages.conf":
    ensure => present
  }

  concat::fragment {"Messages.conf-header":
    target  => "${default_conf_dir}/Messages.conf",
    content => template('bacula/header.conf.erb'),
    order   => '0'
  }

  exec {'breload':
    command     => '/bin/echo "reload" | /sbin/bconsole',
    refreshonly => true,
  }
  
}
