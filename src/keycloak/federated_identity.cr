class Keycloak::FederatedIdentityRepresentation
  include JSON::Serializable
  include JSON::Serializable::Unmapped

  def initialize
  end

  @[JSON::Field(key: "identityProvider")]
  property identity_provider : String?

  @[JSON::Field(key: "userId")]
  property user_id : String?

  @[JSON::Field(key: "userName")]
  property user_name : String?
end
