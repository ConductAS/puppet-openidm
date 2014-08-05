# == Class: openidm::install
#
# This class installs OpenIDM 2.1 (enterprise). Only binaries from
# ForgeRock are supported in subscription agreements with ForgeRock,
# so content of the ZIP archive is installed using Puppet. There is
# currently no RPM packages available for OpenIDM Enterprise builds.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright 2013 Conduct AS
#
class openidm::install {
  
  package { "unzip" : ensure => installed }
  package { "java-1.7.0-openjdk-devel" : ensure => installed }

  file { "/var/tmp/${openidm::binary}":
    ensure => file,
    source => "puppet:///files/${module_name}/${openidm::binary}",
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    mode => '0700',
  }
  
  exec { "install openidm":
    require => Package["unzip"],
    command => "/usr/bin/unzip /var/tmp/${openidm::binary} -d /opt",
    creates => "${openidm::home}"
  }
  
  file { "${openidm::home}/bundle/mysql-connector-java-5.1.22-bin.jar":
    ensure => file,
    source => "puppet:///files/${module_name}/${environment}/config/bundle/mysql-connector-java-5.1.22-bin.jar",
    owner => "root",
    group => "root",
    mode => '0644',
    require => Exec["install openidm"]
  }
}
