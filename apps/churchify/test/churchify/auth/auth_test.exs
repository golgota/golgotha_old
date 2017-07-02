defmodule Churchify.AuthTest do
  use Churchify.DataCase

  alias Churchify.Auth

  @valid_attrs %{email: "kelvin.stinghen@gmail.com"}
  @update_attrs %{email: "ju.andrade@gmail.com"}
  @invalid_attrs %{email: nil}

  describe "users" do
    alias Churchify.Auth.User

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Auth.get_user!(user.id) == user
    end

    test "get_user_by_email!/1 returns the user with given email" do
      user = insert(:user)
      assert Auth.get_user_by_email!(user.email) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Auth.create_user(@valid_attrs)
      assert user.email == "kelvin.stinghen@gmail.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, user} = Auth.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "ju.andrade@gmail.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end

  describe "tokens" do
    alias Churchify.Auth.Token

    test "list_tokens/0 returns all tokens" do
      token = insert(:token)
      assert Auth.list_tokens(preload: :user) == [token]
    end

    test "get_token!/1 returns the token with given id" do
      token = insert(:token)
      assert Auth.get_token!(token.id, preload: :user) == token
    end

    test "create_token/1 with valid data creates a token" do
      assert {:ok, %Token{} = token} = Auth.create_token(insert(:user))
      assert String.length(token.value) >= 96
    end

    test "create_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_token(nil)
    end

    test "delete_token/1 deletes the token" do
      token = insert(:token)
      assert {:ok, %Token{}} = Auth.delete_token(token)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_token!(token.id) end
    end

    test "verify_token/1 must check if the token is valid" do
      user = insert(:user)
      {:ok, token} = Auth.create_token(user)
      assert {:ok, ^user} = Auth.verify_token(token.value)
      assert {:error, :not_found} = Auth.verify_token(token.value)
      assert {:error, :not_found} = Auth.verify_token("inexistent")
      assert {:error, :expired} = Auth.verify_token(insert(:token), 0)
    end
  end
end
