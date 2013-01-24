# == Class: openidm::repository
#
# This class configures the OpenIDM repository. MySQL is currently the
# only supported repository in this module.
#
# === Authors
#
# Eivind Mikkelsen <eivindm@conduct.no>
#
# === Copyright
#
# Copyright 2013 Conduct AS
#
class openidm::repository {

  $conf    = "${openidm::home}/conf"
  $tmpfs   = '/dev/shm'
  $mysql   = "/usr/bin/mysql -u root -h ${database_host} --password=${database_root}"

  file { "${openidm::home}/bundle":
    ensure  => directory,
    recurse => true,
    purge   => false,
    owner   => "${openidm::system_user}",
    group   => "${openidm::system_group}",
    source  => "puppet:///${module_name}/bundle",
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
    command     => "${mysql} < ${tmpfs}/openidm.sql",
    onlyif      => "${mysql} --batch --silent -e 'use ${database_name};' 2>&1 | grep 'Unknown database'",
    subscribe   => File["${tmpfs}/openidm.sql"],
    notify      => Exec["purge secrets"],
    refreshonly => true,
  }

  exec { "purge secrets":
    command     => "/bin/rm -f ${tmpfs}/openidm.sql",
    require     => File["${tmpfs}/openidm.sql"],
    refreshonly => true,
  }

  file { "${conf}/repo.jdbc.json":
    ensure  => file,
    replace => false,
    owner   => "${system_user}",
    group   => "${system_group}",
    content => template("${module_name}/repo.jdbc.json.erb"),
    require => Exec["initialize database"],
  }

}
