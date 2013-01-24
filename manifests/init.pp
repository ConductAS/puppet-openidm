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
  $database_root     = hiera('openidm_database_root'),
  $database_host     = hiera('openidm_database_host', 'localhost'),
  $database_port     = hiera('openidm_database_port', 3306),
  $database_name     = hiera('openidm_database_name', 'openidm'),
  $database_username = hiera('openidm_database_username', 'openidm'),
  $database_password = hiera('openidm_database_password', 'openidm'),
) {

  package { "openidm": ensure => present }

  include openidm::config
  include openidm::keystore
  include openidm::repository

  Class['openidm::config'] -> Class['openidm::keystore']
  Class['openidm::keystore'] -> Class['openidm::repository']
}
