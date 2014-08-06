# == Class: openidm
#
# === Parameters
#
# The module takes the following parameters:
#
# === Examples
#
#  class { openidm:
#    port => 8888,
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
  $port              = hiera('openidm::port', 8080),
  $https_port        = hiera('openidm::https_port', 8443),
  $mutual_auth_port  = hiera('openidm::mutual_auth_port', 8444),
  $home              = hiera('openidm::home', '/opt/openidm'),
  $conf              = hiera('openidm::conf', '/etc/openidm'),
  $binary            = hiera('openidm::binary', 'openidm-2.1.1.zip'),
  $java_home         = hiera('openidm::java_home'),
  $java_opts         = hiera('openidm::java_opts', '-Xmx1024m -Dfile.encoding=UTF-8'),
  $admin_username    = hiera('openidm::admin_username', 'openidm-admin'),
  $admin_password    = hiera('openidm::admin_password', 'openidm-admin'),
  $keystore_file     = hiera('openidm::keystore_file', 'openidm.jkcs'),
  $keystore_alias    = hiera('openidm::keystore_alias', 'openidm-sym-default'),
  $keystore_password = hiera('openidm::keystore_password', 'changeit'),
  $system_user       = hiera('openidm::system_user', 'openidm'),
  $system_group      = hiera('openidm::system_group', 'openidm'),
  $log_directory     = hiera('openidm::log_directory', '/var/log/openidm')
) {

  include openidm::install
  include openidm::service
  include openidm::config
  include openidm::keystore

  Class['openidm::install'] -> Class['openidm::service'] -> 
  Class['openidm::config']  -> Class['openidm::keystore']
}
