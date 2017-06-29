defmodule Churchify.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Auth.User

  schema "auth_users" do
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
