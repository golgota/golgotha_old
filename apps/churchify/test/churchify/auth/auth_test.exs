defmodule Churchify.AuthTest do
  use Churchify.DataCase

  alias Churchify.Auth

  @valid_attrs %{email: "some email"}
  @update_attrs %{email: "some updated email"}
  @invalid_attrs %{email: nil}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Auth.create_user()

    user
  end

  describe "users" do
    alias Churchify.Auth.User

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end

  describe "tokens" do
    alias Churchify.Auth.Token

    def token_fixture(user \\ user_fixture()) do
      {:ok, token} = Auth.create_token(user)

      token
    end

    test "list_tokens/0 returns all tokens" do
      token = token_fixture()
      assert Auth.list_tokens(preload: :user) == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = token_fixture()
      assert Auth.get_token!(token.id, preload: :user) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Auth.create_token(user_fixture())
      assert String.length(token.value) == 96
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_token(nil)
    end

    test "delete_token/1 deletes the token" do
      token = token_fixture()
      assert {:ok, %Token{}} = Auth.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_token!(token.id) end
    end
  end
end
