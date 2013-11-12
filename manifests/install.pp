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

  file { "/opt/openidm":
    ensure => directory,
    source => "puppet:///files/${module_name}/openidm-zip",
    sourceselect => all,
    recurse => true,
    replace => true,
    owner => '${openidm::system_user}',
    group => '${openidm::system_group}',
    mode => '0750'
  }
  
  file { "/opt/openidm/conf":
    ensure => link,
    target => "${openidm::conf}",
    force => true, 
    require => File["/opt/openidm"]
  }
}