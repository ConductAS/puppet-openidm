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
  $port              = hiera('openidm_port', 8443),
  $home              = hiera('openidm_home', '/var/lib/openidm'),
  $admin_username    = hiera('openidm_admin_username', 'openidm-admin'),
  $admin_password    = hiera('openidm_admin_password', 'openidm-admin'),
  $keystore_file     = hiera('openidm_keystore_file', 'openidm.jkcs'),
  $keystore_alias    = hiera('openidm_keystore_alias', 'openidm-sym-secure'),
  $keystore_password = hiera('openidm_keystore_password', 'changeit'),
  $system_user       = hiera('openidm_system_user', 'openidm'),
  $system_group      = hiera('openidm_system_group', 'openidm'),
  $database_host     = hiera('openidm_database_host', 'localhost'),
  $database_port     = hiera('openidm_database_port', 3306),
  $database_name     = hiera('openidm_database_name', 'openidm'),
  $database_username = hiera('openidm_database_username', 'openidm'),
  $database_password = hiera('openidm_database_password', 'openidm'),
) {
  $conf    = "${home}/conf"
  $tmpfs   = '/dev/shm'
  $mysql   = "/usr/bin/mysql -u ${database_username} -h ${database_host} --password=${database_password}"
  $keytool = "/usr/bin/keytool -keystore ${home}/security/${keystore_file} -storepass ${keystore_password} -keypass ${keystore_password} -storetype JCEKS"

  package { "openidm": ensure => present }

  file { "${conf}":
    ensure  => directory,
    recurse => true,
    purge   => true,
    require => Package["openidm"],
    owner   => "${system_user}",
    group   => "${system_group}",
    source  => "puppet:///${module_name}/conf",
  }

  file { "${conf}/jetty.xml":
    ensure  => file,
    require => File["$conf"],
    owner   => "${system_user}",
    group   => "${system_group}",
    content => template("${module_name}/jetty.xml.erb"),
  }

  file { "${conf}/boot/boot.properties":
    ensure  => file,
    require => File["$conf"],
    owner   => "${system_user}",
    group   => "${system_group}",
    content => template("${module_name}/boot.properties.erb"),
  }

  file { "${conf}/repo.jdbc.json":
    ensure  => file,
    owner   => "${system_user}",
    group   => "${system_group}",
    content => template("${module_name}/repo.jdbc.json.erb"),
    require => File["${conf}"],
    
  }

  exec { "generate encryption key":
    cwd     => "${home}",
    command => "${keytool} -genseckey -alias ${keystore_alias} -keyalg AES -keysize 128'",
    onlyif  => "${keytool} -list -alias ${keystore_alias} | grep 'exist'",
    require => File["${home}/conf/boot/boot.properties"],
  }
  
  file { "${home}/security/${keystore_file}":
    ensure      => file,
    owner       => "${system_user}",
    group       => "${system_group}",
    mode        => 600,
    replace     => false,
    require     => Exec["generate encryption key"],
  }

  file { "${tmpfs}/openidm.sql":
    ensure  => file,
    replace => false,
    content => template("${module_name}/openidm.sql.erb"),
    owner   => "${system_user}",
    group   => "${system_group}",
    mode    => 600,
  }
  
  exec { "initialize database":
    cwd         => "${home}",
    command     => "${mysql} < ${tmpfs}/openidm.sql; rm ${tmpfs}/openidm.sql",
    onlyif      => "${mysql} --batch --silent -e 'use ${database_name};' | grep 'Unknown database'",
    subscribe   => File["${tmpfs}/openidm.sql"],
    refreshonly => true,
  }

}
