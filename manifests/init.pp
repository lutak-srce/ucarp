#
# = Class: ucarp
#
# This class manages uCARP
#
class ucarp (
  $ensure            = $::ucarp::params::ensure,
  $package           = $::ucarp::params::package,
  $version           = $::ucarp::params::version,
  $service           = $::ucarp::params::service,
  $service_ensure    = $::ucarp::params::service_ensure,
  $service_enable    = $::ucarp::params::service_enable,
  $file_mode         = $::ucarp::params::file_mode,
  $file_owner        = $::ucarp::params::file_owner,
  $file_group        = $::ucarp::params::file_group,
  $file_vip_common   = $::ucarp::params::file_vip_common,
  $dir_ucarp_confd   = $::ucarp::params::dir_ucarp_confd,
  $ucarp_confd_purge = $::ucarp::params::ucarp_confd_purge,
  $dependency_class  = $::ucarp::params::dependency_class,
  $my_class          = $::ucarp::params::my_class,
  $noops             = undef,
  $autoload_configs  = false,
) inherits ucarp::params {

  ### Input parameters validation
  validate_re($ensure, ['present','absent'], 'Valid values are: present, absent')
  validate_string($package)
  validate_string($version)
  validate_string($service)
  validate_re($service_ensure, ['running','stopped','undef'], 'Valid values are: running, stopped')

  ### Internal variables (that map class parameters)
  if $ensure == 'present' {
    $package_ensure = $version ? {
      ''      => 'present',
      default => $version,
    }
    $file_ensure = present
    $dir_ensure  = directory
  } else {
    $package_ensure = 'absent'
    $file_ensure    = absent
    $dir_ensure     = absent
  }

  ### Extra classes
  if $dependency_class { include $dependency_class }
  if $my_class         { include $my_class         }


  package { 'ucarp':
    ensure => $package_ensure,
    name   => $package,
    noop   => $noops,
  }

  service { 'ucarp':
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Package['ucarp'],
    noop    => $noops,
  }

  # set defaults for file resource in this scope.
  File {
    ensure  => $file_ensure,
    owner   => $file_owner,
    group   => $file_group,
    mode    => $file_mode,
    notify  => Service['ucarp'],
    noop    => $noops,
  }

  file { $dir_ucarp_confd :
    ensure => $dir_ensure,
    purge  => $ucarp_confd_purge,
  }

  # autoload configs from ucarp::vips from hiera
  if ( $autoload_configs == true ) {
    $ucarp_vips = hiera_hash('ucarp::vips', {})
    create_resources(::Ucarp::Vip, $ucarp_vips)
  }

}
# vi:syntax=puppet:filetype=puppet:ts=4:et:nowrap:
