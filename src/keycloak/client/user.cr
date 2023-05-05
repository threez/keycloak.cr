class Keycloak::Client
  # Returns the number of users that match the given criteria.
  # It can be called in three different ways:
  #
  # 1. Don’t specify any criteria and pass. The number of all users within that realm will
  #    be returned.
  # 2. If `search` is specified other criteria such as `lastname`
  #    will be ignored even though you set them. The `search` string
  #    will be matched against the first and lastname, the username
  #    and the email of a user
  # 3. If `search` is unspecified but any of `lastname`, `firstname`,
  #    `email` or `username` those criteria are matched against their
  #    respective fields on a user entity. Combined with a logical and.
  #
  # Params:
  #
  # * `email` A String contained in email, or the complete email, if param "exact" is true
  # * `email_verified` whether the email has been verified
  # * `enabled` Boolean representing if user is enabled or not
  # * `firstname` A String contained in firstName, or the complete firstName, if param "exact" is true
  # * `lastname` A String contained in lastName, or the complete lastName, if param "exact" is true
  # * `search` A String contained in username, first or last name, or email
  # * `username` A String contained in username, or the complete username, if param "exact" is true
  def user_count(*,
                 email : String? = nil,
                 email_verified : Bool? = nil,
                 enabled : Bool? = nil,
                 firstname : String? = nil,
                 lastname : String? = nil,
                 search : String? = nil,
                 username : String? = nil) : Int32
    get_path(url("/users/count"), "user count", Int32)
  end

  def get_user(id : String) : UserRepresentation
    get_path(url("/users/#{id}"), "user", UserRepresentation)
  end

  def get_user_credentials(id : String) : Array(CredentialRepresentation)
    get_path(url("/users/#{id}/credentials"), "user credentials", Array(CredentialRepresentation))
  end

  # Set up a new password for the user.
  #
  # * `id` the id of the user
  # * `cred` the new credentials
  def reset_password(id : String, cred : CredentialRepresentation)
    put_path(url("/users/#{id}/reset-password"), "reset password", cred)
  end

  # Send an email-verification email to the user An email contains
  # a link the user can click to verify their email address.
  #
  # * `id` the id of the user
  # * `client_id` optional client id
  # * `redirect_uri` optional redirect uri
  def send_verify_email(id : String, *,
                        client_id : String? = nil,
                        redirect_uri : String? = nil)
    path = url("/users/#{id}/send-verify-email",
      client_id: client_id, redirect_uri: redirect_uri)
    put_path(path, "send verify email")
  end

  def create_user(user : UserRepresentation)
    post_path(url("/users"), "create user", user)
  end

  def update_user(user : UserRepresentation)
    put_path(url("/users/#{user.id}"), "update user", user)
  end

  def delete_user(id : String)
    delete_path(url("/users/#{id}"), "delete user")
  end

  # Get groups of the given user identified by `id`
  #
  # * `brief` Boolean which defines whether brief representations are returned
  # * `first` Pagination offset
  # * `max` Maximum results size (defaults to 100)
  # * `search` A String contained in username, first or last name, or email
  def user_groups(id : String, *,
                  brief : Bool? = nil,
                  first : Int32? = nil,
                  max : Int32? = nil,
                  search : String? = nil) : Array(GroupRepresentation)
    path = url("/users/#{id}/groups", briefRepresentation: brief,
      first: first, max: max, search: search)
    get_path(path, "user", Array(GroupRepresentation))
  end

  # Get users returns a stream of users, filtered according to query parameters.
  #
  # * `brief` Boolean which defines whether brief representations are returned
  # * `email` A String contained in email, or the complete email, if param "exact" is true
  # * `email_verified` whether the email has been verified
  # * `enabled` Boolean representing if user is enabled or not
  # * `exact` Boolean which defines whether the params "last", "first", "email" and "username" must match exactly
  # * `first` Pagination offset
  # * `firstname` A String contained in firstName, or the complete firstName, if param "exact" is true
  # * `idp_alias` The alias of an Identity Provider linked to the user
  # * `idp_user_id` The userId at an Identity Provider linked to the user
  # * `lastname` A String contained in lastName, or the complete lastName, if param "exact" is true
  # * `max` Maximum results size (defaults to 100)
  # * `q` A query to search for custom attributes, in the format 'key1:value2 key2:value2'
  # * `search` A String contained in username, first or last name, or email
  # * `username` A String contained in username, or the complete username, if param "exact" is true
  def users(*,
            brief : Bool? = nil,
            email : String? = nil,
            email_verified : Bool? = nil,
            enabled : Bool? = nil,
            exact : Bool? = nil,
            first : Int32? = nil,
            firstname : String? = nil,
            idp_alias : String? = nil,
            idp_user_id : String? = nil,
            lastname : String? = nil,
            max : Int32? = nil,
            q : String? = nil,
            search : String? = nil,
            username : String? = nil) : Array(UserRepresentation)
    path = url("/users",
      briefRepresentation: brief,
      email: email,
      emailVerified: email_verified,
      enabled: enabled,
      exact: exact,
      first: first,
      firstName: firstname,
      idpAlias: idp_alias,
      idpUserId: idp_user_id,
      lastName: lastname,
      max: max,
      q: q,
      search: search,
      username: username)
    get_path(path, "user", Array(UserRepresentation))
  end

  # Get sessions associated with the user
  #
  # * `id` the id of the user
  def user_sessions(id : String) : UserSessionRepresentation
    get_path(url("/{realm}/users/{id}/sessions"), "user session", UserSessionRepresentation)
  end
end
