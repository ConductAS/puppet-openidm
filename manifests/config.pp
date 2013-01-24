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

  $conf    = "${openidm::home}/conf"

  file { "${conf}":
    ensure  => directory,
    recurse => true,
    replace => false, # OpenIDM updates configuration files during startup...
    purge   => false,
    require => Package["openidm"],
    owner   => "${openidm::system_user}",
    group   => "${openidm::system_group}",
    source  => "puppet:///${module_name}/conf",
  }

  file { "${conf}/repo.orientdb.json":
    ensure  => absent,
    require => File["${conf}"],
  }

  file { "${conf}/jetty.xml":
    ensure  => file,
    require => File["$conf"],
    owner   => "${system_user}",
    group   => "${system_group}",
    content => template("${module_name}/jetty.xml.erb"),
  }
  
  exec { "remove web console":
    command => "/bin/rm -f ${openidm::home}/bundle/org.apache.felix.webconsole-*.jar",
    require => File["${conf}"],
  }
}
