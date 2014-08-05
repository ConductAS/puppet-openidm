# Puppet Module for ForgeRock OpenIDM

`puppet-openidm` configures OpenIDM with Puppet.

## Usage

    class { 'openidm': 
      port => 8080,
      admin_username => 'openidm-admin',
      admin_password => 'XO5Dg1BRbNBFJYcESNYxvPMz',
    }

## Business logic and configuration

The module assumes configuration is stored outside the installation directory,
e.g. `/etc/openidm` and that OpenIDM is started with either the provided startup
script or manually with `./startup.sh -p /path/to/openidm/conf`.
