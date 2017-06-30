defmodule Churchify.Auth.Token do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Auth.Token
  alias Churchify.Auth.User

  schema "auth_tokens" do
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

	# Generates a random and url-encoded token of given length
  defp generate_token(nil), do: nil
  defp generate_token(user) do
    Phoenix.Token.sign(secret(), "user", user.id)
  end
end
