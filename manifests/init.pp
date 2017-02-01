# == Class: bacula
#
# Full description of class bacula here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'bacula':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class bacula (
    $version              = undef,
    $group                = undef,
    $user                 = undef,
    $conf_base_dir        = undef,
    $default_conf_dir     = undef,
    $bacula_clients_dir   = undef,
    $bacula_storages_dir  = undef,
    $bacula_schedule_dir  = undef,
    $bacula_filesets_dir  = undef,
    $manage_repositorie   = undef,
    $working_directory    = undef,
    $pid_directory        = undef,
    $fd                   = undef,
    $fd_plugin_dir        = undef,
    $fd_config_file       = undef,
    $fd_package_name      = undef,
    $fd_service_name      = undef,
    $fd_max_jobs          = undef,
    $fd_client_name       = $::fqdn,
    $fd_dir_template      = undef,
    $fd_template          = undef,
    $fd_messages          = undef,
  ){

  include stdlib

  if str2bool($manage_repositorie) {
    class {'::bacula::repo':
      version => $version,
    }
  }

  exec{"mkdir -p ${working_directory}":
    path => $::path,
  }->
  file {$working_directory:
    ensure  => directory,
    recurse => true,
    owner   => $bacula_user,
    group   => $bacula_group,
  }

}
