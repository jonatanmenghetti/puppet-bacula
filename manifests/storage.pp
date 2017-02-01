# Class: bacula::storage
#
# This class manages the bacula storage daemon (bacula-sd)
#
# Parameters:
#   $db_backend:
#     The database backend to use. (Currently only supports sqlite)
#   $director_server:
#     The FQDN of the bacula director
#   $director_password:
#     The director's password
#   $storage_server:
#     The FQDN of the storage daemon server
#   $storage_package:
#     The package name to install the storage daemon (Optional)
#   $mysql_package:
#     The package name to install the storage daemon mysql component
#   $sqlite_package:
#     The package name to install the storage daemon sqlite component
#   $console_password:
#     The password for the Console compoenent of the Director service
#   $template:
#     The tempalte to use for generating the bacula-sd.conf file
#     - Default: 'bacula/bacula-sd.conf.erb'
#
# Actions:
#   - Enforce the DB compoenent package package be installed
#   - Manage the /etc/bacula/bacula-sd.conf file
#   - Manage the /mnt/bacula and /mnt/bacula/default directories
#   - Manage the /etc/bacula/bacula-sd.conf file
#   - Enforce the bacula-sd service to be running
#
# Sample Usage:
#
# class { 'bacula::storage':
#   director_server   => 'bacula.domain.com',
#   director_password => 'XXXXXXXXXX',
#   client_package    => 'bacula-client',
# }

class bacula::storage (
    $db_backend           = 'mysql',
    $director             = undef,
    $director_password    = undef,
    $storage_name         = $fqdn,
    $package              = 'bacula-storage',
    $mysql_package        = 'mysql',
    $pgsql_package        = 'postgresql',
    $storage_conf         = '/etc/bacula/bacula-sd.conf',
    $console_password     = undef,
    $template             = 'bacula/bacula-sd.conf.erb',
    $dir_storage_template = 'bacula/storage/director.conf.erb',
    $manage_package       = false,
    $service_name         = 'bacula-sd',
    $bacula_storage_dir   = '/etc/bacula/conf.d/storages/',
    $storage_address      = $::fqdn,
    $port                 = '9103',
    $devices              = undef,
    $exporte              = true,
    $concurrent_jobs      = '6',
) {

  include stdlib

  if !(defined(Class['bacula'])) {
    fail('You must include the bacula base class before using any bacula defined resources')
  }

  $db_package = $db_backend ? {
    'mysql'  => $mysql_package,
    'pgsql' => $pgsql_package,
  }

  if $manage_package {
    package {$package:
      ensure   => latest,
      provider => $::package_provider,
    } ->
    file { ['/var/lib/bacula',
            '/var/run/bacula',
            '/etc/bacula/bacula-sd.d']:
      ensure => directory,
      owner  => 'bacula',
      group  => 'bacula',
    } ~>
    service { $service_name:
      ensure  => running,
      enable  => true,
    }
  }

  file { $storage_conf:
    ensure  => file,
    content => template($template),
  }

}
