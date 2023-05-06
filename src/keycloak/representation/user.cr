require "./base"

class Keycloak::Representation::User < Keycloak::Representation::Base
  @[JSON::Field(key: "access")]
  property access : Hash(String, Bool) { }

  @[JSON::Field(key: "attributes")]
  property attributes : Hash(String, Array(String)) { }

  @[JSON::Field(key: "clientConsents")]
  property client_consents : Array(UserConsent) { }

  @[JSON::Field(key: "clientRoles")]
  property client_roles : Hash(String, String) { } # TODO: which type is correct here?

  @[JSON::Field(key: "createdTimestamp", converter: Time::EpochMillisConverter)]
  property created_timestamp : Time?

  @[JSON::Field(key: "credentials")]
  property credentials : Array(Credential) { }

  @[JSON::Field(key: "disableableCredentialTypes")]
  property disableable_credential_types : Array(String) { }

  @[JSON::Field(key: "email")]
  property email : String?

  @[JSON::Field(key: "emailVerified")]
  property email_verified : Bool?

  @[JSON::Field(key: "enabled")]
  property enabled : Bool?

  @[JSON::Field(key: "federatedIdentities")]
  property federated_identities : Array(FederatedIdentity) { }

  @[JSON::Field(key: "federationLink")]
  property federation_link : String?

  @[JSON::Field(key: "firstName")]
  property firstname : String?

  @[JSON::Field(key: "groups")]
  property groups : Array(String)?

  @[JSON::Field(key: "id")]
  property id : String?

  @[JSON::Field(key: "lastName")]
  property lastname : String?

  @[JSON::Field(key: "notBefore", converter: Time::EpochConverter)]
  property not_before : Time?

  @[JSON::Field(key: "origin")]
  property origin : String?

  @[JSON::Field(key: "realmRoles")]
  property realm_roles : Array(String) { }

  @[JSON::Field(key: "requiredActions")]
  property required_actions : Array(String) { }

  @[JSON::Field(key: "self")]
  property self : String?

  @[JSON::Field(key: "serviceAccountClientId")]
  property service_account_client_id : String?

  @[JSON::Field(key: "username")]
  property username : String?

  @[JSON::Field(key: "totp")]
  property totp : Bool?
end
