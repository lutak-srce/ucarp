#
# = Class: ucarp::ucarp
#
# This module contains defaults for ucarp module
#
class ucarp::params {

  $ensure         = 'present'
  $version        = undef

  $service_ensure = 'running'
  $service_enable = true

  $file_mode         = '0600'
  $file_owner        = 'root'
  $file_group        = 'root'
  $ucarp_confd_purge = true

  $dependency_class = '::ucarp::dependency'
  $my_class         = undef

  # install package depending on major version
  case $::osfamily {
    default: {}
    /(RedHat|redhat|amazon|Debian|debian|Ubuntu|ubuntu)/: {
      $package           = 'ucarp'
      $service           = 'ucarp'
      $vip_common        = 'vip-common.conf'
      $dir_ucarp_confd   = '/etc/ucarp'
    }
  }

}
