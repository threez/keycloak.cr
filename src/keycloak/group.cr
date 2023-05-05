class Keycloak::GroupRepresentation
  include JSON::Serializable
  include JSON::Serializable::Unmapped

  def initialize
  end

  @[JSON::Field(key: "access")]
  property access : Hash(String, Bool) { }

  @[JSON::Field(key: "attributes")]
  property attributes : Hash(String, Array(String)) { }

  @[JSON::Field(key: "clientConsents")]
  property client_consents : Array(UserConsentRepresentation) { }

  @[JSON::Field(key: "clientRoles")]
  property client_roles : Hash(String, String) { } # TODO: which type is correct here?

  @[JSON::Field(key: "id")]
  property id : String?

  @[JSON::Field(key: "name")]
  property name : String?

  @[JSON::Field(key: "realmRoles")]
  property realm_roles : Array(String) { }

  @[JSON::Field(key: "subGroups")]
  property sub_groups : Array(GroupRepresentation) { }
end
