define bacula::dir::client (
  $bacula_clients_dir = $baucla::params::bacula_clients_dir,
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
    template =>
  }
}
