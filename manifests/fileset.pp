# Define: 
# Parameters:
# 
#
define bacula::fileset (
  $fileset                = undef,
  $session                = 'include',
  $files                  = [],
  $vss                    = undef,
  $compression            = 'gzip',
  $signature              = 'SHA1',
  $option_exclude         = undef,
  $plugins                 = [],

  $exclude_files          = [],
  $exclude_dir_containing = [],
  $wildfiles              = [],
  $wilddir                = [],

  $basejob                = undef,
  $accurate               = undef,
  $verity                 = undef,
  $onefs                  = undef,
  $noatime                = undef,
  $mtimeonly              = undef,
  $keepatime              = undef,
  $checkfilechanges       = undef,
  $wild                   = undef,
  $regex                  = undef,
  $regexfile              = undef,
  $regexdir               = undef,
  $aclsupport             = undef,
  $xattrsupport           = undef,
  $ignore_case            = undef,
  $fstype                 = undef,
  $drivetype              = undef,
  $hfsplussupport         = undef,
  $strippath              = undef,
  $config_template_path   = 'bacula/conf.d/fileset',
  ) {
 
  include stdlib

  $bacula_user          = getparam(Class['bacula'],'user')
  $bacula_group         = getparam(Class['bacula'],'group')
  $_default_conf_dir    = getparam(Class['bacula'],'default_conf_dir')
  $_bacula_filesets_dir = getparam(Class['bacula'],'bacula_filesets_dir')
  $conf_base_dir        = getparam(Class['bacula'],'conf_base_dir')
  $default_conf_dir     = "${conf_base_dir}/${_default_conf_dir}"

  $bacula_filesets_dir  = "${default_conf_dir}/${_bacula_filesets_dir}"


  if $name {
    $_name = $name
  } else {
    $_name = $title
  }

  if $fileset {
    $_fileset = $fileset
  } else {
    $_fileset = $name
  }

  $_option_exclude = bool2str(str2bool($option_exclude),'yes','no')

  if $vss {
    $_vss = bool2str(str2bool($vss),'yes','no')
  }

  #Validate input $files
  if $files.is_a(Array) {
    $_files = $files
  } else {
    $_files = any2array($files)
  }

  if $plugins.is_a(Array) {
    $_plugins = $plugins
  } else {
    $_plugins = any2array($plugins)
  }

  #Validate input $exclude_dir_containing
  if $exclude_dir_containing.is_a(Array) {
    $_exclude_dir_containing =  $exclude_dir_containing
  } else {
    $_exclude_dir_containing = any2array($exclude_dir_containing)
  }

  #Validate input $wildfile
  if $wildfiles.is_a(Array) {
    $_wildfiles = $wildfiles
  } else {
    $_wildfiles = any2array($wildfiles)
  }

  if $wilddirs.is_a(Array) {
    $_wilddirs = $wilddirs
  } else {
    $_wilddirs = any2array($wilddir)
  }

  if $session == 'include' {
    $concat_order = 10
  } else {
    $concat_order = 20
  }

  # Check if fileset resource already exists
  if ! defined(Concat["fileset-${_fileset}"]) {
    concat { "fileset-${_fileset}":
      path   => "${bacula_filesets_dir}/${_name}.conf",
      ensure => present,
      owner  => $bacula_user,
      group  => $bacula_group,
    }

    concat::fragment {"fileset-${_name}-header":
      target  => "fileset-${_fileset}",
      content => template("$config_template_path/header.conf.erb"),
      order   => '0',
    }

    concat::fragment {"fileset-${_name}-foot":
      target  => "fileset-${_fileset}",
      content => template("$config_template_path/foot.conf.erb"),
      order   => '9999',
    }
  }

  concat::fragment {"${_name}-session":
    target  => "fileset-${_fileset}",
    content => template("$config_template_path/session.conf.erb"),
    order   => $concat_order,
  }
}