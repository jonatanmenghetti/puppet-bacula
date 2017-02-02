# Define: 
# Parameters:
# 
#
define bacula::job (
    $fileset                                = undef,
    $pool                                   = undef,
    $client                                 = undef,
    Boolean $is_def                         = false,
    Optional[Boolean] $enabled              = undef,
    Optional[Enum['Backup','Restore','Verify','Admin']] $type  = undef,
    Optional[Enum['Full','Incr','Diff','InitCatalog','Catalog','VolToCatalog','DiskToCatalog']] $level =  undef,
    $accurrate                              = undef,
    $verify_job                             = undef,
    $job_def                                = undef,
    $bootstrap                              = undef,
    $write_bootstrap                        = undef,
    $base                                   = undef,
    $message                                = undef,
    $full_pool                              = undef,
    $diff_pool                              = undef,
    $incr_pool                              = undef,
    $schedule_name                          = undef,
    $storage                                = undef,
    $max_start_delay                        = undef,
    $max_run_time                           = undef,
    $max_run_time_inc                       = undef,
    $max_run_time_dif                       = undef,
    $max_run_sched_time                     = undef,
    $max_wait_time                          = undef,
    $max_full_interval                      = undef,
    Optional[Boolean] $prefer_mounted_vol   = undef,
    Optional[Boolean] $prune_jobs           = undef,
    Optional[Boolean] $prune_files          = undef,
    Optional[Boolean] $prune_volumes        = undef,
    $run_script                             = undef,
    $run_before                             = undef,
    $run_after                              = undef,
    $run_after_failed                       = undef,
    $client_run_before                      = undef,
    $client_run_after                       = undef,
    Optional[Boolean] $rerun_failed_levels  = undef,
    Optional[Boolean] $spool_data           = undef,
    Optional[Boolean] $spool_attr           = undef,
    $spool_size                             = undef,
    $where                                  = undef,
    $prefix                                 = undef,
    $suffix                                 = undef,
    $strip                                  = undef,
    $regex_where                            = undef,
    Optional[Enum['always','ifnewer','ifolder','never']] $replace              = undef,
    Optional[Boolean] $prefix_liks          = undef,
    $max_concurrent_jobs                    = undef,
    Optional[Boolean] $reschedule_error     = undef,
    $reschedule_interval                    = undef,
    $reschedule_time                        = undef,
    Optional[Boolean] $allow_duplicate      = undef,
    Optional[Boolean] $cancel_low_dupl      = undef,
    Optional[Boolean] $cancel_queued_dupl   = undef,
    Optional[Boolean] $cancel_run_dpl       = undef,
    $run                                    = undef,
    Optional[Integer[1,10]] $priority       = undef,
    Optional[Boolean]$allow_mixed_priority  = undef,
    Optional[Boolean]$write_part_after      = undef,
) {

  include stdlib

  if !(defined(Class['bacula'])) {
    fail('You must include the bacula base class before using any bacula defined resources')
  }

  if $enabled {
    $_enabled              = bool2str(str2bool($enabled),'yes','no')
  }

  if $prefer_mounted_vol {
    $_prefer_mounted_vol   = bool2str(str2bool($prefer_mounted_vol),'yes','no')
  }

  if $prune_jobs {
    $_prune_jobs           = bool2str(str2bool($prune_jobs),'yes','no')
  }

  if $prune_files {
    $_prune_files          = bool2str(str2bool($prune_files),'yes','no')
  }

  if $prune_volumes {
    $_prune_volumes        = bool2str(str2bool($prune_volumes),'yes','no')
  }

  if $rerun_failed_levels {
    $_rerun_failed_levels  = bool2str(str2bool($rerun_failed_levels),'yes','no')
  }

  if $spool_data {
    $_spool_data           = bool2str(str2bool($spool_data),'yes','no')
  }

  if $spool_attr {
    $_spool_attr           = bool2str(str2bool($spool_attr),'yes','no')
  }

  if $prefix_liks {
    $_prefix_liks          = bool2str(str2bool($prefix_liks),'yes','no')
  }

  if $reschedule_error {
    $_reschedule_error     = bool2str(str2bool($reschedule_error),'yes','no')
  }

  if $allow_duplicate {
    $_allow_duplicate      = bool2str(str2bool($allow_duplicate),'yes','no')
  }

  if $cancel_low_dupl {
    $_cancel_low_dupl      = bool2str(str2bool($cancel_low_dupl),'yes','no')
  }

  if $cancel_queued_dupl {
    $_cancel_queued_dupl   = bool2str(str2bool($cancel_queued_dupl),'yes','no')
  }

  if $cancel_run_dpl {
    $_cancel_run_dpl       = bool2str(str2bool($cancel_run_dpl),'yes','no')
  }

  if $allow_mixed_priority {
    $_allow_mixed_priority = bool2str(str2bool($allow_mixed_priority),'yes','no')
  }

  if $write_part_after {
    $_write_part_after     = bool2str(str2bool($write_part_after),'yes','no')
  }

  if $priority {
    $_priority = $priority
  }


  # Is Job Definer
  if $is_def {

    if ! $message {
      fail("** Parameter message is required for JobDefs. **")
    }
    
     if ! $pool {
      fail("** Parameter pool is required for JobDefs. **")
    }

     if ! $fileset {
      fail("** Parameter fileset is required for JobDefs. **")
    }
  
    # Force type Backup for undefined parâmeter when is DefJob
    if $type {
      $_type = $type
    } else {
      $_type = 'Backup'
    }

    # Force FULL backup for undefined parâmeter when is DefJob
    if !$level {
      $_level = 'Full'
    } else {
      $_level = $level
    }

    concat::fragment {"JobDefs.conf-${name}":
      target  => 'JobdefsResource',
      content => template('bacula/conf.d/job.conf.erb'),
      order   => '0'
    }
  } else {

    if $type {
      $_type = $type
    }

    if $level {
      $_level = $level
    }
    if ! $client {
      fail("** Parameter client is required for JobDefs. **")
    }
  
    concat::fragment {"client-${client}-config-${name}":
      target  => "client-${client}-config",
      content => template('bacula/conf.d/job.conf.erb'),
      order   => '10'
    }

  }

}