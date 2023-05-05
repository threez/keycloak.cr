class Keycloak::CredentialRepresentation
  include JSON::Serializable
  include JSON::Serializable::Unmapped

  def initialize
    @type = "password"
  end

  def self.temporary_password(password : String)
    cred = new
    cred.temporary = true
    cred.value = password
    cred
  end

  def self.password(password : String)
    cred = new
    cred.temporary = false
    cred.value = password
    cred
  end

  @[JSON::Field(key: "createdDate", converter: Time::EpochMillisConverter)]
  property created_date : Time?

  @[JSON::Field(key: "credentialData")]
  property credential_data : String?

  @[JSON::Field(key: "id")]
  property id : String?

  @[JSON::Field(key: "priority")]
  property priority : Int32?

  @[JSON::Field(key: "secretData")]
  property secret_data : String?

  @[JSON::Field(key: "temporary")]
  property temporary : Bool?

  @[JSON::Field(key: "type")]
  property type : String?

  @[JSON::Field(key: "userLabel")]
  property user_label : String?

  @[JSON::Field(key: "value")]
  property value : String?
end
