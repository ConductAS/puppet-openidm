# == Class: openidm
#
# This 
#
# === Parameters
#
# The module takes the following parameters:
#
# [*port*]
#   The port which OpenIDM accepts connections. Only secure transport
#   (SSL) is supported with this module.
#
# === Examples
#
#  class { openidm:
#    port => 8443,
#  }
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright 2013 Conduct AS
#
class openidm (
  $port              = 8443,
  $admin_username    = 'openidm-admin',
  $admin_password    = hiera('openidm_admin_password', 'openidm-admin'),
  $database_host     = 'localhost',
  $database_port     = 3306,
  $database_name     = 'openidm',
  $database_username = 'openidm',
  $database_password,
) {

  package { "openidm": ensure => present }
  
  file { "${openidm::home}/conf":
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => Package["openidm"],
    owner   => "${opendidm::system_user}",
    group   => "${openidm::system_group}",
    source  => "puppet:///${module_name}/conf",
  }

  file { "${openidm::home}/conf/jetty.xml":
    ensure  => file,
    require => File["${openidm::home}/conf"],
    owner   => "${openidm::system_user",
    group   => "${openidm::system_group",
    content => template("${module_name}/jetty.xml"),
  }

}
