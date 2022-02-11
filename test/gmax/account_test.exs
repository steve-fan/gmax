defmodule Gmax.AccountTest do
  use Gmax.DataCase

  alias Gmax.Account

  describe "users" do
    alias Gmax.Account.User

    @valid_attrs %{
      access_token: "some access_token",
      access_token_expired_at: ~N[2010-04-17 14:00:00],
      avatar_url: "some avatar_url",
      email: "client@gmail.com",
      name: "some name",
      oauth_provider: "some oauth_provider",
      oauth_provider_id: "some oauth_provider_id",
      refresh_token: "some refresh_token"
    }
    @update_attrs %{
      access_token: "some updated access_token",
      access_token_expired_at: ~N[2011-05-18 15:01:01],
      avatar_url: "some updated avatar_url",
      email: "client_b@gmail.com",
      name: "some updated name",
      oauth_provider: "some updated oauth_provider",
      oauth_provider_id: "some updated oauth_provider_id",
      refresh_token: "some updated refresh_token"
    }
    @invalid_attrs %{
      access_token: nil,
      access_token_expired_at: nil,
      avatar_url: nil,
      email: nil,
      name: nil,
      oauth_provider: nil,
      oauth_provider_id: nil,
      refresh_token: nil
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.access_token == "some access_token"
      assert user.access_token_expired_at == ~N[2010-04-17 14:00:00]
      assert user.avatar_url == "some avatar_url"
      assert user.email == "client@gmail.com"
      assert user.name == "some name"
      assert user.oauth_provider == "some oauth_provider"
      assert user.oauth_provider_id == "some oauth_provider_id"
      assert user.refresh_token == "some refresh_token"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.access_token == "some updated access_token"
      assert user.access_token_expired_at == ~N[2011-05-18 15:01:01]
      assert user.avatar_url == "some updated avatar_url"
      assert user.email == "client_b@gmail.com"
      assert user.name == "some updated name"
      assert user.oauth_provider == "some updated oauth_provider"
      assert user.oauth_provider_id == "some updated oauth_provider_id"
      assert user.refresh_token == "some updated refresh_token"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end

    test "get_user_by returns a user matches the clauses" do
      user_fixture()
      user = Account.get_user_by(email: "client@gmail.com")
      assert "client@gmail.com" == user.email
      non_exists_user = Account.get_user_by(email: "non@gmail.com")
      refute non_exists_user
    end

    test "get_user_by! throws exception when there is no match" do
      user_fixture()
      assert Account.get_user_by!(email: "client@gmail.com")
      assert catch_error(Account.get_user_by!(email: "non@gmail.com"))
    end
  end
end
