# keycloak [![.github/workflows/ci.yml](https://github.com/threez/oidc.cr/actions/workflows/ci.yml/badge.svg)](https://github.com/threez/oidc.cr/actions/workflows/ci.yml) [![https://threez.github.io/oidc.cr/](https://badgen.net/badge/api/documentation/green)](https://threez.github.io/oidc.cr/)

Access the keycloak admin API from Crystal.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     keycloak:
       github: threez/keycloak.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "keycloak"

KC = Keycloak::Client.new("https://id.example.de/realms/me/.well-known/openid-configuration", "client-id", "secret")
puts KC.user_groups("1f74cab4-8d90-4956-bb54-ecac9176404f")
```

TODO: Write usage instructions here

## Implemented

*  Users
*  Groups

## TODO

### Keycloak

*  Attack Detection
*  Authentication Management
*  Client Attribute Certificate
*  Client Initial Access
*  Client Registration Policy
*  Client Role Mappings
*  Client Scopes
*  Clients
*  Component
*  Identity Providers
*  Key
*  Protocol Mappers
*  Realms Admin
*  Role Mapper
*  Roles
*  Roles (by ID)
*  Scope Mappings

### Extensions

* [Organizations (PhaseTwo)](https://phasetwo.io/api/phase-two-admin-rest-api/)

## Contributing

1. Fork it (<https://github.com/threez/keycloak.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Vincent Landgraf](https://github.com/threez) - creator and maintainer
