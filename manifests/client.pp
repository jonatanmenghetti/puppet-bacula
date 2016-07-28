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
# class { 'bacula::client':
#   director_server   => 'bacula.domain.com',
#   director_password => 'XXXXXXXXXX',
#   client_package    => 'bacula-client',
# }
class bacula::client (
  $client_conf            = undef,
  $client_conf_template   = undef,
  $bacula_clients_dir     = undef,
  $dir_client_template    = undef,
  $client_package         = undef,
  $client_service         = undef,
  $director_password,
  $director_server,
  $pid_dir                = undef,
  $working_dir            = undef,
  $plugin_dir             = undef,
  $max_jobs               = undef,
  $jobs                   = {},
  $hostname               = ,
  $catalog,
  $is_exported            = undef,
  $clientname             = undef,
  $port                   = undef,
  $manage_firewall        = undef,
  $config_ensure          = undef,
) {

  if !(defined(Class['bacula'])) {
      fail('You must include the bacula base class before using any bacula defined resources')
  }

  $director_name_array  = split($director_server,'[.]')
  $director_name        = $director_name_array[0]

  if str2bool($plugin_dir) {
    $fd_plugin_dir = $plugin_dir
  } else {
    $fd_plugin_dir = $::architecture ? {
      'x86_64' => '/usr/lib64/bacula',
      default  => '/usr/lib/bacula',
    }
  }

  package {$client_package:
    ensure   => latest,
  } ->
  file { ['/var/lib/bacula',
          '/var/run/bacula']:
    ensure => directory,
    owner  => 'bacula',
    group  => 'bacula',
    before => Service [$client_service],
  } ~>
  service { $client_service:
    ensure  => running,
    enable  => true,
    require => Package [$client_package],
  }

  file { $client_conf:
    ensure  => file,
    content => template($client_conf_template),
    notify  => Service [$client_service],
    require => Package [$client_package],
  }

  if $manage_firewall {
    firewall { '200 Bacula':
      dport  => $port,
      proto  => tcp,
      action => accept,
    }
  }

  if $is_exported {
    @@file { "${clientname}.conf":
      ensure  => $config_ensure,
      path    => "${bacula_clients_dir}/${clientname}.conf",
      content => template($dir_client_template),
      tag     => 'baculaclient',
      notify  => Exec['breload'],
    }
  }
}