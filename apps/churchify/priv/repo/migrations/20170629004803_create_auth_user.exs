defmodule Churchify.Repo.Migrations.CreateChurchify.Auth.User do
  use Ecto.Migration

  def change do
    create table(:auth_users) do
      add :email, :string

      timestamps()
    end

    create unique_index(:auth_users, [:email])
  end
end
