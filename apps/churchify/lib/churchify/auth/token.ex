defmodule Churchify.Auth.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Auth.Token
  alias Churchify.Auth.User

  schema "tokens" do
    field :value, :string

    belongs_to :user, User

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(%Token{} = token, user) do
    token
    |> cast(%{}, [])
    |> put_assoc(:user, user)
    |> put_change(:value, generate_token(user))
    |> validate_required([:value, :user])
    |> unique_constraint(:value)
  end

  @doc """
  The secret for generating tokens.
  """
  def secret do
    Application.get_env(:churchify, :secret_key_base)
  end

	@doc """
  Generates a random and url-encoded token of given length
  """
  def generate_token(nil), do: nil
  def generate_token(%User{} = user) do
    generate_token(user.id)
  end
  def generate_token(user_id) when is_integer(user_id) do
    Phoenix.Token.sign(secret(), "user", user_id)
  end
end
