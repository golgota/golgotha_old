defmodule Churchify.Auth do
  @moduledoc """
  The boundary for the Auth system.
  """

  import Ecto.Query, warn: false
  alias Churchify.Repo

  alias Churchify.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by his email.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!("existent@mail.com")
      %User{}

      iex> get_user!("inexistent@mail.com")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_email!(email), do: Repo.get_by!(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Churchify.Auth.Token

  @doc """
  Returns the list of tokens.

  ## Examples

      iex> list_tokens()
      [%Token{}, ...]

  """
  def list_tokens(opts \\ []) do
    Token
    |> Repo.all()
    |> Repo.preload(opts[:preload])
  end

  @doc """
  Gets a single token.

  Raises `Ecto.NoResultsError` if the Token does not exist.

  ## Examples

      iex> get_token!(123)
      %Token{}

      iex> get_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_token!(id, opts \\ []) do
    Token
    |> Repo.get!(id)
    |> Repo.preload(opts[:preload])
  end

  @doc """
  Creates a token.

  ## Examples

      iex> create_token(user)
      {:ok, %Token{}}

      iex> create_token(nil)
      {:error, %Ecto.Changeset{}}

  """
  def create_token(user \\ nil) do
    %Token{}
    |> Token.changeset(user)
    |> Repo.insert()
  end

  @doc """
  Deletes a Token.

  ## Examples

      iex> delete_token(token)
      {:ok, %Token{}}

      iex> delete_token(token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_token(%Token{} = token) do
    Repo.delete(token)
  end

  @token_max_age 30 * 60

  @doc """
  Verifies the given token.
  """
  def verify_token(value, max_age \\ @token_max_age)
  def verify_token(nil, _), do: {:error, :not_found}
  def verify_token(value, max_age) when is_bitstring(value) do
    Token
    |> where([t], t.value == ^value)
    |> Repo.one()
    |> verify_token(max_age)
  end
  def verify_token(%Token{} = token, max_age) do
    token
    |> Repo.preload(:user)
    |> Repo.delete!()
    |> do_verify_token(max_age)
  end

  alias Phoenix.Token, as: PToken

  defp do_verify_token(%Token{value: value, user: user, user_id: user_id}, max_age) do
    case PToken.verify(Token.secret(), "user", value, max_age: max_age) do
      {:ok, ^user_id} -> {:ok, user}
      {:error, _} = result -> result
    end
  end
end
