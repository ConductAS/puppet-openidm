# == Class: openidm::keystore
#
# This class ensures that a keystore with a randomly generated symmetric
# encryption key is set up, and updates the boot.properties accordingly.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright 2013 Conduct AS
#
class openidm::keystore {

  $conf    = "${openidm::home}/conf"
  $keytool = "/usr/bin/keytool -keystore ${openidm::home}/security/${openidm::keystore_file} \
    -storepass ${openidm::keystore_password} -keypass ${openidm::keystore_password} -storetype JCEKS"

  exec { "generate encryption key":
    cwd     => "${home}",
    command => "${keytool} -genseckey -alias ${openidm::keystore_alias} -keyalg AES -keysize 128",
    onlyif  => "${keytool} -list -alias ${openidm::keystore_alias} | grep 'exist'",
    logoutput => "on_failure",
  }

  file { "${openidm::home}/security/${openidm::keystore_file}":
    ensure      => file,
    owner       => "${openidm::system_user}",
    group       => "${openidm::system_group}",
    mode        => 600,
    replace     => false,
    require     => Exec["generate encryption key"],
  }

  file { "${conf}/boot/boot.properties":
    ensure  => file,
    require => Exec["generate encryption key"],
    owner   => "${openidm::system_user}",
    group   => "${openidm::system_group}",
    content => template("${module_name}/boot.properties.erb"),
  }
}
