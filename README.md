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
`puppet:///conf/openidm/$environment` to `/etc/openidm`.

### Directory structure for OpenIDM configuration on Puppet Master
```
/path/to/configuration/openidm
  /path/to/configuration/openidm/$environment
    /path/to/configuration/openidm/$environment/conf
      /path/to/configuration/openidm/$environment/conf/authentication.json
      ...
    /path/to/configuration/openidm/$environment/script
      /path/to/configuration/openidm//development/script/access.js
      ...    
    /path/to/configuration/openidm//development/workflow
      /path/to/configuration/openidm//development/workflow/example.bpmn20.xml
      ...
```

### fileserver.conf
```
[conf]
  path /path/to/configuration
  allow *
```

