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

  @doc """
  Sends a new magic login token to the user or email.
  """
  def send_token(nil), do: {:error, :not_found}
  def send_token(email) when is_bitstring(email) do
    User
    |> Repo.get_by(email: email)
    |> send_token()
  end
  def send_token(user) do
    user
    |> create_token()
    |> do_send_token(user)
  end

  defp do_send_token({:ok, %Token{} = token}, user) do
    # token
    # |> AuthEmail.session_link(user)
    # |> Mailer.deliver_now()

    {:ok, user}
  end
  defp do_send_token(result, _), do: result

  @token_max_age 30 * 60

  defp token_expiration_time do
    NaiveDateTime.add(NaiveDateTime.utc_now(), (@token_max_age * -1), :second)
  end

  @doc """
  Verifies the given token.
  """
  def verify_token(value) when is_bitstring(value) do
    Token
    |> where([t], t.value == ^value)
    |> where([t], t.inserted_at > ^token_expiration_time())
    |> Repo.one()
    |> verify_token()
  end
  def verify_token(nil), do: {:error, :invalid}
  def verify_token(%Token{} = token) do
    token
    |> Repo.preload(:user)
    |> Repo.delete!()
    |> do_verify_token()
  end

  defp do_verify_token(%Token{value: value, user: user, user_id: user_id}) do
    case Phoenix.Token.verify(Token.secret(), "user", value,
                              max_age: @token_max_age) do
      {:ok, ^user_id} -> {:ok, user}
      result -> result
    end
  end
end
