class Keycloak::UserSessionRepresentation
  include JSON::Serializable
  include JSON::Serializable::Unmapped

  def initialize
  end

  @[JSON::Field(key: "id")]
  property id : String?

  @[JSON::Field(key: "username")]
  property username : String?

  @[JSON::Field(key: "userId")]
  property user_id : String?

  @[JSON::Field(key: "ipAddress")]
  property ip_address : String?

  @[JSON::Field(key: "start", converter: Time::EpochMillisConverter)]
  property start : Time?

  @[JSON::Field(key: "lastAccess", converter: Time::EpochMillisConverter)]
  property last_access : Time?

  @[JSON::Field(key: "rememberMe")]
  property remember_me : Bool?

  @[JSON::Field(key: "clients")]
  property clients : Hash(String, String) { }
end
