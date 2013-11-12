# == Class: openidm
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
  $port              = hiera('openidm::port', 8443),
  $home              = hiera('openidm::home', '/opt/openidm'),
  $conf              = hiera('openidm::conf', '/etc/openidm'),
  $binary            = hiera('openidm::binary', 'openidm-2.1.zip'),
  $java_home         = hiera('openidm::java_home'),
  $admin_username    = hiera('openidm::admin_username', 'openidm-admin'),
  $admin_password    = hiera('openidm::admin_password', 'openidm-admin'),
  $keystore_file     = hiera('openidm::keystore_file', 'openidm.jkcs'),
  $keystore_alias    = hiera('openidm::keystore_alias', 'openidm-sym-secure'),
  $keystore_password = hiera('openidm::keystore_password', 'changeit'),
  $system_user       = hiera('openidm::system_user', 'openidm'),
  $system_group      = hiera('openidm::system_group', 'openidm')
) {

  include openidm::install
  include openidm::config
  include openidm::keystore

  Class['openidm::install'] -> Class['openidm::config']
  Class['openidm::config']  -> Class['openidm::keystore']
}
