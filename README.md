# Puppet Module for ForgeRock OpenIDM

`puppet-openidm` configures OpenIDM with Puppet.

## Usage

    class { 'openidm': 
      port => 8080,
      admin_username => 'openidm-admin',
      admin_password => 'XO5Dg1BRbNBFJYcESNYxvPMz',
    }

## MySQL JDBC driver for OpenIDM repository

MySQL Connector/J is licensed under GNU GPL, and thus not included:

  * Download MySQL JDBC driver from http://www.mysql.com/downloads/connector/j/
  * Extract mysql-connector-java-5.x.xx-bin.jar from the archive
  * Place the JAR in the module's files/bundle directory
