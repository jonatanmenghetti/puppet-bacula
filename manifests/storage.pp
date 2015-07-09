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
# class { 'bacula::client':
#   director_server   => 'bacula.domain.com',
#   director_password => 'XXXXXXXXXX',
#   client_package    => 'bacula-client',
# }

class bacula::storage(
    $db_backend,
    $director_server,
    $director_password,
    $storage_server,
    $storage_package = '',
    $mysql_package,
    $pgsql_package,
    $console_password,
    $template = 'bacula/bacula-sd.conf.erb',
    $manage_package = false,
    $service_name = 'bacula-sd',
) {

  $db_package = $db_backend ? {
    'mysql'  => $mysql_package,
    'pgsql' => $pgsql_package,
  }


}
