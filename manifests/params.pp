class bacula::params {
  $bacula_clients_dir     = '/etc/bacula/conf.d/Clients',
  $client_conf            = '/etc/bacula/bacula-fd.conf',
  $client_conf_template   = 'bacula-fd.conf.erb',
  $dir_client_template    = 'bacula-client.conf.erb',
  $pid_dir                = '/var/run/bacula',
  $working_dir            = '/var/lib/bacula',
}
