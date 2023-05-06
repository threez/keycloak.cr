require "json"

class Keycloak::Representation::Base
  include JSON::Serializable
  include JSON::Serializable::Unmapped

  def initialize
  end
end
