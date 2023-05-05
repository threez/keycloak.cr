require "spec"
require "../src/keycloak"

KC = Keycloak::Client.new(ENV["CONFIG_URL"], ENV["CONFIG_NAME"], ENV["CONFIG_KEY"])
