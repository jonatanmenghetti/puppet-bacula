# Class: bacula::repo
#
# This class manage the repo
#

class bacula::repo (
  $version           = 5,
) {

  if !(defined(Class['bacula'])) {
      fail('You must include the bacula base class before using any bacula defined resources')
  }

  if $version == 7 {

    file {'/etc/yum.repos.d/epel-bacula7.repo':
      ensure => absent,
    }

    yumrepo { 'epel_bacula7':
      descr => 'Bacula backports from rawhide',
      baseurl => 'http://repos.fedorapeople.org/repos/slaanesh/bacula7/epel-$releasever/$basearch/',
      enabled => true,
      skip_if_unavailable => true,
      gpgkey => 'http://repos.fedorapeople.org/repos/slaanesh/bacula7/RPM-GPG-KEY-slaanesh',
      gpgcheck => true,
    }
  }
}
