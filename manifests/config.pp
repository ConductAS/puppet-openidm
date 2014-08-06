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
    source => [ "puppet:///conf/${module_name}/${environment}" ],
    sourceselect => all,
    recurse => true,
    replace => true,
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    mode => '0750'
  }
  
  file { "${openidm::conf}/conf":
     ensure => directory,
     owner => "${openidm::system_user}",
     group => "${openidm::system_group}",
     mode => '0750',
     require => File["${openidm::conf}"]
  }
  
  file { "${openidm::conf}/conf/boot":
    ensure => directory,
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    mode => '0750',
    require => File["${openidm::conf}/conf"]
  }
  
  file { "${openidm::conf}/conf/jetty.xml":
    ensure  => file,
    owner   => "${openidm::system_user}",
    group   => "${openidm::system_group}",
    content => template("${module_name}/jetty.xml.erb"),
    require => File["${openidm::conf}/conf"]
  }

  file { "${openidm::home}/update_admin_crypto.sh":
    source => [ "puppet:///modules/${module_name}/update_admin_crypto.sh" ],
    owner => "root",
    group => "root",
    mode => '0750',
  }
}