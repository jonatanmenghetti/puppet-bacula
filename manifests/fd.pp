# class bacula::client
#
# This class manage the bacula client (client-fd)
#
# Parameters:
#   $director_server:
#     The FQDN of the bacula director.
#   $director_password:
#     The director's passowrd.
#   $client_package:
#       The name of the package to install the bacula-fd service.
#   $client_conf:
#       File name of bacula-fd configuration file
#   $client_conf_template:
#       Template for bacula-fd configuration file
#   $client_service:
#       The name of bacula-fd service
#   $package_provider:
#       Package provider (for solaris only)
#   $pid_dir:
#       The bacula-fd pid dir
#   $working_dir:
#       The bacula-fd working dir
#   $max_jobs:
#       The max cuncorrent Jobs can be running on bacula-fd.
#
# Actions:
#   - Enforce the $client_package package be installed
#   - Manage the /etc/bacula/bacula-fd.conf file
#   - Enforce the bacula-fd service to be running
#
# Sample Usage:
#
# bacula::client {$::fqdn:
#   director_server   => 'bacula.domain.com',
#   director_password => 'XXXXXXXXXX',
#   client_package    => 'bacula-client',
# }
 # $hostname               = $::fqdn,
  # $client_conf            = 'bacula-fd.conf',
  # $client_conf_template   = undef,
  # $dir_client_template    = undef,
  # $client_package         = 'bacula-fd',
  # $client_service         = 'bacula-fd',
  # $pid_dir                = undef,
  # $working_dir            = undef,
  # $plugin_dir             = undef,
  # $max_jobs               = undef,
  # $is_exported            = undef,
  # $clientname             = $title,
  # $port                   = undef,
  # $config_ensure          = undef,

define bacula::fd (
  $password,
  $director,
  $catalog,
  $package_name        = undef,
  $service_name        = undef,
  $config_file         = undef,
  $max_jobs            = undef,
  $configure_director  = undef,
  $fd_template         = undef,
  $dir_template        = undef,
  $address             = undef,
  $plugin_dir          = undef,
  $working_directory   = undef,
  $pid_directory       = undef,
  $messages            = undef,
  Boolean $is_fd       = true,
) {

  if !(defined(Class['bacula'])) {
      fail('You must include the bacula base class before using any bacula defined resources')
  }

   $_client_name       = $title

  $bacula_user          = getparam(Class['bacula'],'user')
  $bacula_group         = getparam(Class['bacula'],'group')
  
  #Default: conf.d
  $_default_conf_dir    = getparam(Class['bacula'],'default_conf_dir') 

  #Default: clients
  $_bacula_clients_dir  = getparam(Class['bacula'],'bacula_clients_dir') 

  #Default: /etc/bacula
  $conf_base_dir        = getparam(Class['bacula'],'conf_base_dir') 
  
  #Default: /etc/bacula/conf.d
  $default_conf_dir     = "${conf_base_dir}/${_default_conf_dir}" 

  # Default: /etc/bacula/conf.d/clients
  $bacula_clients_dir   = "${default_conf_dir}/${_bacula_clients_dir}" 

  # $director_name_array  = split($director_server,'[.]')
  # $director_name        = $director_name_array[0]

  if ! $package_name {
    $_package_name    = getparam(Class['bacula'],'fd_package_name') 
  } else {
    $_package_name    = $package_name
  }

  if ! $service_name {
    $_service_name    = getparam(Class['bacula'],'fd_service_name') 
  } else {
    $_service_name    = $service_name
  }

  if ! $fd_template {
    $_fd_template     = getparam(Class['bacula'],'fd_template')
  } else {
    $_fd_template     = $fd_template
  }

  if ! $dir_template {
    $_dir_template     = getparam(Class['bacula'],'fd_dir_template')
  } else {
    $_dir_template     = $dir_template
  }

  if ! $config_file {
    $_config_file       = getparam(Class['bacula'],'fd_config_file')
  } else {
    $_config_file    = $config_file
  }

  if ! $plugin_dir {
    $_plugin_dir      = getparam(Class['bacula'],'fd_plugin_dir')
  } else {
    $_plugin_dir      = $plugin_dir
  }

  if ! $working_directory {
    $_working_directory     = getparam(Class['bacula'],'working_directory')
  } else {
    $_working_directory     = $working_directory
  }

  if ! $pid_directory {
    $_pid_directory     = getparam(Class['bacula'],'pid_directory')
  } else {
    $_pid_directory     = $pid_directory
  }

  if ! $max_jobs {
    $_max_jobs     = getparam(Class['bacula'],'fd_max_jobs')
  } else {
    $_max_jobs     = $max_jobs
  }

  if ! $messages {
    $_messages = getparam(Class['bacula'],'fd_messages')
  } else {
    $_messages = $messages
  }

  if ! defined(Package[$_package_name]) {
    package {$_package_name:
      ensure   => latest,
    }->
    service { $_service_name:
      ensure  => running,
      enable  => true,
    }
  }
  if $is_fd {
    file { "fd-configure-${client_name}":
      path    => "${conf_base_dir}/${_config_file}",
      ensure  => file,
      content => template($_fd_template),
      notify  => Service[$_service_name],
    }
  }

  if $configure_director {
      @file { "${_client_name}.conf":
        ensure  => file,
        path    => "${bacula_clients_dir}/${_client_name}.conf",
        content => template($_dir_template),
        tag     => 'baculaclient',
        notify  => Exec['breload'],
      }
    } else {
      
    concat { "client-${_client_name}-config":
      path   => "${bacula_clients_dir}/${_client_name}.conf",
      ensure => present,
      owner  => $bacula_user,
      group  => $bacula_group,
    }

    concat::fragment {"client-${_client_name}-config":
      target  => "client-${_client_name}-config",
      content => template($_dir_template),
      order   => '1'
    }
  }
}