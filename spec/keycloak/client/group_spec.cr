require "../../spec_helper"

describe Keycloak::Client do
  describe "#group_count" do
    it "should work" do
      KC.group_count.should eq(3)
    end
  end

  describe "#groups" do
    it "finds all top level groups" do
      groups = KC.groups
      groups.size.should eq(2)
      groups[0].name.should eq("Test1")
      groups[1].name.should eq("Test2")
    end

    it "can search for groups" do
      groups = KC.groups(search: "Test2")
      groups.size.should eq(1)
    end
  end

  describe "#user_group_count" do
    it "handles group counts" do
      KC.user_group_count("1f74cab4-8d90-4956-bb54-ecac9176404f").should eq(1)
      KC.user_group_count("49e85e70-e8c6-44a4-a731-8dfdf29aaa56").should eq(2)
    end
  end

  describe "#get_group" do
    it "unknown group" do
      expect_raises Keycloak::NotFoundError do
        KC.get_group("501b932e-8f82-4dd2-a3b8-994b6f07c282")
      end
    end

    it "should get a group by id" do
      group = KC.get_group("7d28bd4d-b902-436f-8d73-b4f140276f56")
      group.name.should eq("Test1")
    end
  end

  describe "#group_members" do
    it "unknown group" do
      expect_raises Keycloak::NotFoundError do
        KC.group_members("501b932e-8f82-4dd2-a3b8-994b6f07c282")
      end
    end

    it "should find the members of a group" do
      members = KC.group_members("7d28bd4d-b902-436f-8d73-b4f140276f56")
      members.size.should eq(1)
      members[0].firstname.should eq("Test")
      members[0].lastname.should eq("User 2")
    end
  end

  describe "#add_user_to_group and #remove_user_from_group" do
    it "should be able to add and remove users from groups" do
      # get first group
      group = KC.groups.first
      group_id = group.id.not_nil!

      # find all users that are not part of the group
      members = KC.group_members(group_id).not_nil!.map(&.id).map(&.not_nil!)
      member_size = members.size
      users = KC.users
      users.reject! { |u| members.includes?(u.id.not_nil!) }
      users.size.should_not eq(0)
      user_id = users.first.id.not_nil!

      # add user to the group
      KC.add_user_to_group(user_id: user_id,
        group_id: group_id)
      KC.group_members(group_id).not_nil!.size.should eq(member_size + 1)

      # remove the user from the group again
      KC.remove_user_from_group(user_id: user_id,
        group_id: group_id)
      KC.group_members(group_id).not_nil!.size.should eq(member_size)
    end
  end

  describe "#create_group and #delete_group" do
    it "can create new users and delete them, without parent" do
      group = Keycloak::GroupRepresentation.new
      group.name = "A new group"
      KC.create_group(group)
      group.id.should_not be(nil)
      KC.delete_group(group.id.not_nil!)
    end

    it "can create new users and delete them, with parent" do
      parent_group_id = KC.groups.first.id.not_nil!
      group = Keycloak::GroupRepresentation.new
      group.name = "A new group"
      KC.create_group(group, parent: parent_group_id)
      group.id.should_not be(nil)
      KC.delete_group(group.id.not_nil!)
    end
  end
end
