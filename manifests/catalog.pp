# Define: 
# Parameters:
# 
#
define bacula::catalog (
  $db_name = undef,
  $db_host = undef,
  $db_user = undef,
  $db_pwd  = undef,
  $db_port = undef,
) {

  $conf_base_dir        = getparam(Class['bacula'],'conf_base_dir')
  $_default_conf_dir    = getparam(Class['bacula'],'default_conf_dir')
  $default_conf_dir     = "${conf_base_dir}/${_default_conf_dir}"

  if $name {
    $_name = $name
  } else {
    $_name = $title
  }

  concat::fragment { $_name:
    target  => "${default_conf_dir}/Catalogs.conf",
    content => template('bacula/conf.d/catalog.conf.erb'),
    order   => '5'
  }

}