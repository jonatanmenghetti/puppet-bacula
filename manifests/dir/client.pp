define bacula::dir::client (
  $bacula_clients_dir = '/etc/bacula/conf.d/Clients',
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
    path => "$baucla::params::bacula_clients_dir/$name.conf",
    template => template($bacula::params::dir_client_template),
  }
}
