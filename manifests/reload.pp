class bacula::reload {

  exec {'breload':
    command => '/bin/echo "reload" | /sbin/bconsole',
  }

}
