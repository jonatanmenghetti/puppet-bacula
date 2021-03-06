# Class: bacula::repo
#
# This class manage the repo
#

class bacula::repo (
  $version           = 7,
) {

  include stdlib

  if !(defined(Class['bacula'])) {
    fail('You must include the bacula base class before using any bacula defined resources')
  }

  $bacula_version = getparam(Class['bacula'],'version')

  yumrepo { 'epel_bacula7':
    descr               => 'Bacula backports from rawhide',
    baseurl             => 'http://repos.fedorapeople.org/repos/slaanesh/bacula7/epel-$releasever/$basearch/',
    enabled             => true,
    skip_if_unavailable => true,
    gpgkey              => 'http://repos.fedorapeople.org/repos/slaanesh/bacula7/RPM-GPG-KEY-slaanesh',
    gpgcheck            => true,
  }
}
