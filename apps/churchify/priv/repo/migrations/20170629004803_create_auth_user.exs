defmodule Churchify.Repo.Migrations.CreateChurchify.Auth.User do
  use Ecto.Migration

  def change do
    create table(:auth_users) do
      add :email, :string

      timestamps()
    end

  end
end
