class bacula::dir (
  $manage_clients = true,
) {

  if $manage_clients {
    File <<| tag == "baculaclient" |>>
  }
}
