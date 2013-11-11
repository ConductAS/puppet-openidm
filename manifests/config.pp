# == Class: openidm::config
#
# This class manages required configuration files for OpenIDM.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright 2013 Conduct AS
#
class openidm::config {

  file { "${openidm::conf}":
    ensure => directory,
    source => [ "puppet:///files/${module_name}/${environment}/config" ],
    sourceselect => all,
    recurse => true,
    replace => true,
    owner => "${system_user}",
    group => "${system_group}",
    mode => '0750'
  }

  file { "${openidm::conf}/jetty.xml":
    ensure  => file,
    owner   => "${system_user}",
    group   => "${system_group}",
    content => template("${module_name}/jetty.xml.erb"),
    require => File["${openidm::conf}"]
  }
  
  exec { "remove web console":
    command => "/bin/rm -f ${openidm::home}/bundle/org.apache.felix.webconsole-*.jar",
  }   
}