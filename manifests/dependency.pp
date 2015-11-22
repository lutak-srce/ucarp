#
# = Class: ucarp::dependency
#
class ucarp::dependency {

  # install package depending on major version
  case $::osfamily {
    default: {}
    /(redhat|amazon)/: {
      include ::yum::repo::epel
    }
    /(debian|ubuntu)/: {
    }
  }

}
