# Class: bacula::repo
#
# This class manage the repo
#

class bacula::repo (
  $version           = 5,
) {

  if $version == 7 {
    yumrepo { 'epel-bacula7':
      name => 'Bacula backports from rawhide',
      baseurl => 'http://repos.fedorapeople.org/repos/slaanesh/bacula7/epel-$releasever/$basearch/',
      enabled => true,
      skip_if_unavailable => true,
      gpgkey => 'http://repos.fedorapeople.org/repos/slaanesh/bacula7/RPM-GPG-KEY-slaanesh',
      gpgcheck => true,
    }
  }
}
