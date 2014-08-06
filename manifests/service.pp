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

  file { "/etc/init.d/openidm":
    ensure => file,
    owner => "root",
    group => "root",
    mode => 0700,
    content => template("${module_name}/openidm.rc.erb")
  }
  
  service { "${module_name}":
      require => File['/etc/init.d/openidm'],
      ensure => running,
      hasstatus => true,
      hasrestart => true,
      start => "service ${module_name} start",
      stop => "service ${module_name} stop",
      restart => "service ${module_name} restart"
  }  
  
}