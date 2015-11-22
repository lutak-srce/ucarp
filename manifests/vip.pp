#
# = Define: ucarp::vip
#
# This class adds virtual ip (VIP) to ucarp
#
define ucarp::vip (
  $address,
  $password       = '',
  $bind_interface = '',
  $source_address = '',
  $options        = '--shutdown',
  $template       = 'ucarp/vip.conf.erb',
) {

  ### Input parameters validation
  validate_re($name, '^[0-2][0-9][0-9]$', 'Provided name is not in 001-255 range.')
  if ! is_ip_address($address) { fail('Provided IP address is not valid.') }

  # turn ucarp on
  include ::ucarp

  # set defaults for file resource in this scope.
  File {
    ensure  => $::ucarp::file_ensure,
    owner   => $::ucarp::file_owner,
    group   => $::ucarp::file_group,
    mode    => $::ucarp::file_mode,
    notify  => Service['ucarp'],
    noop    => $ucarp::noops,
  }

  file { "${::ucarp::dir_ucarp_confd}/vip-${name}.conf" :
    content => template($template)
  }


}
# vi:syntax=puppet:filetype=puppet:ts=4:et:nowrap:
