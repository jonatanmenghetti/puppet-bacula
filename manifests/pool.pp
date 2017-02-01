# Class: 
#
#
define bacula::pool (
  $type             = 'Backup',
  $auto_prune       = true,
  $max_volumes      = undef,
  $max_jobs         = 1,
  $volume_duration  = "23 hours",
  $volume_retention = "7 days",
  $file_retention   = '7 days',
  $job_retention    = '7 days',
  $label            = '${Client}-${Pool}-${NumVols}',
  $recycle          = true,
  $recycle_old      = true,
  $purge_action     = 'Truncate',
  $purge_old        = true,
  $storage          = undef,
) {

  include stdlib

  $bacula_user    = getparam(Class['bacula'],'user')
  $bacula_group   = getparam(Class['bacula'],'group')
  $_auto_prune    = bool2str(str2bool($auto_prune), 'yes', 'no')
  $_recycle       = bool2str(str2bool($recycle),'yes','no')
  $_recycle_old   = bool2str(str2bool($recycle_old),'yes','no')
  $_purge_old     = bool2str(str2bool($purge_old),'yes','no')


  if $name {
    $_name = $name
  } else {
    $_name = $title
  }

concat::fragment {$_name:
  target  => 'PoolsResource',
  content => template('bacula/conf.d/pool.conf.erb'),
  order   => '10'
}

}