require "./base"

class Keycloak::Representation::UserConsent < Keycloak::Representation::Base
  @[JSON::Field(key: "clientId")]
  property client_id : String?

  @[JSON::Field(key: "createdDate", converter: Time::EpochMillisConverter)]
  property created_date : Time?

  @[JSON::Field(key: "grantedClientScopes")]
  property granted_client_scopes : Array(String) { }

  @[JSON::Field(key: "lastUpdatedDate", converter: Time::EpochMillisConverter)]
  property last_updated_date : Time?
end
