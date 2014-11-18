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
  package { "${java_devel_pkg}" : ensure => installed }
  
  group { "openidm":
      ensure => present,
  }
  
  user { "openidm":
      require => Group["openidm"],
      ensure => present,
      home => "${openidm::home}",
      groups => ["openidm"]
  }

  file { "/var/tmp/${openidm::binary}":
    require => User["openidm"],
    ensure => file,
    source => "puppet:///files/${module_name}/${openidm::binary}",
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    mode => '0700',
  }
  
  exec { "install openidm":
    require => [ Package["unzip"], File["/var/tmp/${openidm::binary}"] ],
    command => "/usr/bin/unzip /var/tmp/${openidm::binary} -d /opt",
    creates => "${openidm::home}"
  }
  
  file { "${openidm::home}/bundle/mysql-connector-java-5.1.28.jar":
    ensure => file,
    source => "puppet:///files/${module_name}/mysql-connector-java-5.1.28.jar",
    require => Exec["install openidm"]
  }
  
  file { "${openidm::log_directory}":
    ensure => directory,
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    recurse => true
  }
  
  file { "${openidm::log_directory}/logs":
    ensure => directory,
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    mode => "0750",
    recurse => true
  }
  
  file { "${openidm::log_directory}/audit":
    ensure => directory,
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}",
    mode => "0700",
    recurse => true
  }
  
  file { "${openidm::home}/logs":
    ensure => link,
    target => "${openidm::log_directory}/logs",
    force => true,
    require => Exec["install openidm"]
  }
  
  file { ["/tmp/openidm", "/tmp/openidm/felix-cache"]:
    ensure => directory,
    recurse => true,
    owner => "${openidm::system_user}",
    group => "${openidm::system_group}"
  }
  
  file { "${openidm::home}/felix-cache":
    ensure => link,
    target => "/tmp/openidm/felix-cache",
    force => true,
    require => [ Exec["install openidm"], File["/tmp/openidm/felix-cache"] ]
  }
  
  file { "${openidm::home}/startup.sh":
    ensure => present,
    mode => "0600",
    require => Exec["install openidm"]
  }
  
  file { "${openidm::home}/audit":
    ensure => link,
    target => "${openidm::log_directory}/audit",
    force => true,
    require => Exec["install openidm"]
  }
}
