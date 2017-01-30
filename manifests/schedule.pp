# Define: 
# Parameters:
# 
#
define bacula::schedule (
    $level                = undef,
    $pool                 = undef,
    $pool_full            = undef,
    $pool_diff            = undef,
    $pool_incr            = undef,
    $when                 = undef,
    $start                = undef,
    $schedule_name        = undef,
    $config_template_path = 'bacula/conf.d/schedule'
) {
  
  include stdlib

  $bacula_user          = getparam(Class['bacula'],'user')
  $bacula_group         = getparam(Class['bacula'],'group')
  $conf_base_dir        = getparam(Class['bacula'],'conf_base_dir')
  $_default_conf_dir    = getparam(Class['bacula'],'default_conf_dir')
  $_bacula_schedule_dir = getparam(Class['bacula'],'bacula_schedule_dir')
  $default_conf_dir     = "${conf_base_dir}/${_default_conf_dir}"

  $bacula_schedule_dir  = "${default_conf_dir}/${_bacula_schedule_dir}"
  $_name                = $title

  if $schedule_name {
    $_schedule = $schedule_name
  } else {
    $_schedule = $name
  }

  # Check if fileset resource already exists
  if ! defined(Concat["schedule-${_schedule}"]) {
    concat { "schedule-${_schedule}":
      path   => "${bacula_schedule_dir}/${_schedule}.conf",
      ensure => present,
      owner  => $bacula_user,
      group  => $bacula_group,
    }

    concat::fragment {"schedule-${_name}-header":
      target  => "schedule-${_schedule}",
      content => template("$config_template_path/header.conf.erb"),
      order   => '0',
    }

    concat::fragment {"schedule-${_name}-foot": 
      target  => "schedule-${_schedule}",
      content => template("$config_template_path/foot.conf.erb"),
      order   => '9999',
    }
  }

  concat::fragment {"schedule-${_name}-schedule":
    target  => "schedule-${_schedule}",
    content => template("$config_template_path/schedule.conf.erb"),
    order   => 10,
  }

}