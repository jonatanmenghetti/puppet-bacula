define bacula::dir::client (
  $bacula_clients_dir     = '/etc/bacula/conf.d/Clients',
  $dir_client_template    = 'bacula-client.conf.erb',
  $name,
  $password,
  $director,
  $tag,
  $jobs,
  $schedule,
  $address,
  $catalog,
){
  file { "$name.conf":
    path => "$bacula_clients_dir/$name.conf",
    template => template($dir_client_template),
  }
}
