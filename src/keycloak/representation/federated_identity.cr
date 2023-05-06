require "./base"

class Keycloak::Representation::FederatedIdentity < Keycloak::Representation::Base
  @[JSON::Field(key: "identityProvider")]
  property identity_provider : String?

  @[JSON::Field(key: "userId")]
  property user_id : String?

  @[JSON::Field(key: "userName")]
  property user_name : String?
end
