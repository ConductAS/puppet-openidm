# == Class: openidm::service
#
# This class manages the OpenIDM service.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright 2013 Conduct AS
#
class openidm::service {

  file { "/etc/init.d/opendim":
    ensure => file,
    owner => "root",
    group => "root"
    mode => 0700,
    content => template("${module_name}/openidm.rc.erb")
  }
  
  service { "openidm":
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      start => "service ${name} start",
      stop => "service ${name} stop",
      restart => "service ${name} restart"
  }  
  
}