class Keycloak::Client
  # Returns the number of groups for the realm
  def group_count : Int32
    get_path(url("/groups/count"), "group count", Hash(String, Int32))["count"]
  end

  # Returns the number of groups of the user
  def user_group_count(id : String) : Int32
    get_path(url("/users/#{id}/groups/count"), "user group count", Hash(String, Int32))["count"]
  end

  # Get group hierarchy.
  #
  # * `brief` Boolean which defines whether brief representations are returned
  # * `first` Pagination offset
  # * `max` Maximum results size (defaults to 100)
  # * `q` A query to search for custom attributes, in the format 'key1:value2 key2:value2'
  # * `search` A String contained in username, first or last name, or email
  def groups(*,
             brief : Bool? = nil,
             exact : Bool? = nil,
             first : Int32? = nil,
             max : Int32? = nil,
             q : String? = nil,
             search : String? = nil) : Array(GroupRepresentation)
    path = url("/groups", briefRepresentation: brief, exact: exact,
      first: first, max: max, q: q, search: search)
    get_path(path, "groups", Array(GroupRepresentation))
  end

  def get_group(id : String) : GroupRepresentation
    get_path(url("/groups/#{id}"), "group", GroupRepresentation)
  end

  def create_group(user : GroupRepresentation, *, parent : String? = nil)
    path = if parent.nil?
             url("/groups")
           else
             url("/groups/#{parent}/children")
           end

    post_path(path, "create group", user)
  end

  def delete_group(id : String)
    delete_path(url("/groups/#{id}"), "delete group")
  end

  # Get groups members returns a stream of users, filtered according to query parameters
  #
  # * `brief` Boolean which defines whether brief representations are returned
  # * `first` Pagination offset
  # * `max` Maximum results size (defaults to 100)
  def group_members(id : String, *,
                    brief : Bool? = nil,
                    first : Int32? = nil,
                    max : Int32? = nil) : Array(UserRepresentation)
    get_path(url("/groups/#{id}/members"), "group members", Array(UserRepresentation))
  end

  def add_user_to_group(*, user_id : String, group_id : String)
    put_path(url("/users/#{user_id}/groups/#{group_id}"), "add user to group")
  end

  def remove_user_from_group(*, user_id : String, group_id : String)
    delete_path(url("/users/#{user_id}/groups/#{group_id}"), "remove user from group")
  end
end
