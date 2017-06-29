defmodule Churchify.Repo.Migrations.CreateChurchify.Auth.Token do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :value, :string
      add :user_id, references(:auth_users, on_delete: :nothing)

      timestamps(updated_at: false)
    end

    create index(:auth_tokens, [:user_id])
    create unique_index(:auth_tokens, [:value])
  end
end
