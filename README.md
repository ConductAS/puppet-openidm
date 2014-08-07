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
e.g. `/etc/openidm` and that OpenIDM is started with the startup script
provided in `/etc/init.d/openidm`.

The module attempts to copy configuration files from
`puppet:///files/openidm/$environment` to `/etc/openidm`.

### Example

#### Puppet Master directory structure for configuration
```
/usr/share/puppet/files/openidm
  $environment/
    conf/
      authentication.json
      ...
    script/
      access.js
      ...    
```

#### fileserver.conf
```
[files]
  path /usr/share/puppet/files
  allow *
```

