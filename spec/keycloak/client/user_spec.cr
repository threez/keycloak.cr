require "../../spec_helper"

describe Keycloak::Client do
  describe "#user_count" do
    it "should work" do
      KC.user_count.should eq(3)
    end
  end

  describe "#user_groups" do
    it "unknown group" do
      expect_raises Keycloak::NotFoundError do
        KC.user_groups("501b932e-8f82-4dd2-a3b8-994b6f07c282")
      end
    end

    it "should find the groups fo a user" do
      groups = KC.user_groups("1f74cab4-8d90-4956-bb54-ecac9176404f")
      groups.size.should eq(1)
      groups[0].name.should eq("Test2")
    end
  end

  describe "#create_user and #delete_user" do
    it "can create new users and delete them" do
      user = Keycloak::UserRepresentation.new
      user.firstname = "Test"
      user.lastname = "User 2"
      user.email = "test2@example.com"
      user.username = "testuser-2345"
      KC.create_user(user)
      user.id.should_not be(nil)
      KC.delete_user(user.id.not_nil!)
    end
  end

  describe "#reset_password" do
    it "unknown user" do
      expect_raises Keycloak::NotFoundError do
        creds = Keycloak::CredentialRepresentation.password("1234")
        KC.reset_password("501b932e-8f82-4dd2-a3b8-994b6f07c282", creds)
      end
    end

    it "can reset password of existing users" do
      creds = Keycloak::CredentialRepresentation.password("1234")
      user_id = KC.users(max: 1).first.id.not_nil!
      user_id.should_not eq("")
      KC.reset_password(user_id, creds)
    end
  end

  describe "#send_verify_email" do
    it "unknown user" do
      expect_raises Keycloak::NotFoundError do
        KC.send_verify_email("501b932e-8f82-4dd2-a3b8-994b6f07c282")
      end
    end

    it "can send email to existing users" do
      user_id = KC.users(max: 1).first.id.not_nil!
      user_id.should_not eq("")
      KC.send_verify_email(user_id)
    end
  end
end
