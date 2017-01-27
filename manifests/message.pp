# Define: 
# Parameters:
# 
#
define bacula::message (
  $mail_command,
  $mail,
  $console,
  $append,
) {

  include stdlib

  $conf_base_dir        = getparam(Class['bacula'],'conf_base_dir')
  $_default_conf_dir    = getparam(Class['bacula'],'default_conf_dir')
  $default_conf_dir     = "${conf_base_dir}/${_default_conf_dir}"

  if $name {
    $_name = $name
  } else {
    $_name = $title
  }

  concat::fragment { $_name:
    target  => "${default_conf_dir}/Messages.conf",
    content => template('bacula/conf.d/message.conf.erb'),
    order   => '5'
  }

}