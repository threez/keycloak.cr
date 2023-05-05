require "http/client"
require "oidc"

require "./keycloak/*"
require "./keycloak/client/*"

module Keycloak
  VERSION = "0.1.0"

  class Error < Exception; end

  class NotFoundError < Error; end

  class Client
    DEFAULT_HEADERS = HTTP::Headers{
      "Content-Type" => "application/json",
      "Accept"       => "application/json",
      "User-Agent"   => "keycloak.cr/#{VERSION} Crystal/#{Crystal::VERSION}",
    }

    @token : OAuth2::AccessToken?
    @token_valid_until : Time?

    def initialize(config_url : String, client_id : String, client_secret : String)
      initialize(OIDC::Client.new(config_url, client_id, client_secret, redirect_uri: "/"))
    end

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
        puts obj.to_json # FIXME: remove later
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

        unless obj.nil?
          puts obj.to_json # FIXME: remove later
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
