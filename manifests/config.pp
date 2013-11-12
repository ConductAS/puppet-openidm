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
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    mode => '0750'
  }
  
  file { "${openidm::conf}/jetty.xml":
    ensure  => file,
    owner   => "${openidm::system_user}",
    group   => "${openidm::system_group}",
    content => template("${module_name}/jetty.xml.erb"),
    require => File["${openidm::conf}"]
  }
  
  file { "/opt/openidm/conf":
    ensure => link,
    target => "${openidm::conf}/conf",
    force => true, 
    require => File["/opt/openidm"]
  }
  
  file { "/opt/openidm/script":
    ensure => link,
    target => "${openidm::conf}/script",
    force => true,
    require => File["/opt/openidm"]
  }
  
  exec { "remove web console":
    command => "/bin/rm -f ${openidm::home}/bundle/org.apache.felix.webconsole-*.jar",
    require => File["/opt/openidm/conf"]
  }
}