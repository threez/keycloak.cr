require "http/client"
require "oidc"

require "./keycloak/*"
require "./keycloak/representation/*"
require "./keycloak/client/*"

# Access the keycloak [admin API](https://www.keycloak.org/docs-api/21.1.1/rest-api/index.html) from Crystal.
#
# This package provides a `Keycloak::Client` to manage certain objects
# in keycloak via the admin API. With this additional functionality, not
# directly provided can be implemented with ease.
module Keycloak
  VERSION = "0.1.1"

  # Base for all keycloak errors, simplifies "catch all" handling
  class Error < Exception; end

  # Error that is returned in case of HTTP `404` from the server. This
  # us used in case the resource is not found on the server side. E.g. user
  # not found.
  class NotFoundError < Error; end

  # The client has to be used by a correctly configured Keycloak Client.
  # The client needs to have enabled service account capalibity:
  #
  # ![Client Config](https://github.com/threez/keycloak.cr/blob/master/assets/Client.png?raw=true)
  #
  # Depending on the desired funcations the respective roles have to
  # be assigned to the client, in this example the user and grou roles
  # are maked yellow for easier visibility:
  #
  # ![Client Roles](https://github.com/threez/keycloak.cr/blob/master/assets/Roles.png?raw=true)
  class Client
    include UserClient
    include GroupClient

    DEFAULT_HEADERS = HTTP::Headers{
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => "keycloak.cr/#{VERSION} Crystal/#{Crystal::VERSION}",
    }

    @token : OAuth2::AccessToken?
    @token_valid_until : Time?

    # Create a new client based on the given url, client and secret.
    #
    # * `config_url` the url usually of the keycloak config url, usually ends with `".well-known/openid-configuration"`
    # * `client_id` the id of the client to use
    # * `client_secret` the secret to authenticate the client
    #
    def initialize(config_url : String, client_id : String, client_secret : String)
      initialize(OIDC::Client.new(config_url, client_id, client_secret, redirect_uri: "/"))
    end

    # Create a new client using an already existing OIDC client.
    def initialize(@client : OIDC::Client)
      @base = @client.config.issuer.gsub("/realms", "/admin/realms")
    end

    private def delete_path(path : String, desc : String)
      with_http_client do |http_client|
        res = http_client.delete(path, DEFAULT_HEADERS)
        if res.status_code != 204
          raise Error.new("failed to #{desc} due to: #{res.status}: #{res.body}")
        end
      end
    end

    private def post_path(path : String, desc : String, obj)
      with_http_client do |http_client|
        res = http_client.post(path, DEFAULT_HEADERS, obj.to_json)
        if res.status_code != 201
          raise Error.new("failed to #{desc} due to: #{res.status}: #{res.body}")
        end

        if obj.responds_to? :id=
          if location = res.headers["Location"]?
            obj.id = location.split("/").last
          end
        end
      end
    end

    private def put_path(path : String, desc : String, obj = nil)
      with_http_client do |http_client|
        data = ""

        # if data is nil, don't send anything
        unless obj.nil?
          data = obj.to_json
        end

        res = http_client.put(path, DEFAULT_HEADERS, data)
        if res.status_code == 404
          raise NotFoundError.new("#{desc} not found")
        elsif res.status_code != 204
          raise Error.new("failed to #{desc} due to: #{res.status}: #{res.body}")
        end
      end
    end

    private def get_path(path : String, object_name : String, klass)
      obj = nil
      with_http_client do |http_client|
        res = http_client.get(path, DEFAULT_HEADERS)
        if res.status_code == 200
          obj = klass.from_json(res.body)
        elsif res.status_code == 404
          raise NotFoundError.new("#{object_name} not found")
        else
          raise Error.new("failed to fetch #{object_name} due to: #{res.status}: #{res.body}")
        end
      end
      obj.not_nil!
    end

    private def with_http_client(&block : (HTTP::Client) ->)
      with_token do |token|
        @http_client ||= HTTP::Client.new(uri.hostname.not_nil!, tls: (uri.scheme == "https"))
        token.authenticate(@http_client.not_nil!)
        block.call(@http_client.not_nil!)
      end
    end

    private def url(relative_path, **kwargs)
      String.build do |s|
        s << @base
        s << relative_path
        args = kwargs.to_h.reject { |_, v| v.nil? }
          .transform_values { |v| [v.to_s] of String }
          .transform_keys(&.to_s)
        if args.size > 0
          s << "?"
          s << URI::Params.encode(args)
        end
      end
    end

    private def uri : URI?
      @uri ||= URI.parse(@client.config.issuer)
    end

    private def with_token(&block : (OAuth2::AccessToken) ->)
      @token = nil if !@token_valid_until.nil? && Time.local > @token_valid_until.not_nil!
      @token ||= begin
        token = @client.get_access_token_using_client_credentials
        if expires_in = token.expires_in
          @token_valid_until = Time.local + Time::Span.new(seconds: expires_in)
        else
          @token_valid_until = Time.local + Time::Span.new(days: 365 * 10) # 10 years
        end
        token
      end
      block.call(@token.not_nil!)
    end
  end
end
