defmodule Churchify.Repo.Migrations.RenamePeopleContactInfo do
  use Ecto.Migration

  def change do
    drop unique_index(:auth_users, [:email])
    rename table(:auth_users), to: table(:users)
    create unique_index(:users, [:email])

    drop unique_index(:auth_tokens, [:value])
    drop index(:auth_tokens, [:user_id])
    rename table(:auth_tokens), to: table(:tokens)
    execute """
    ALTER TABLE tokens
    RENAME CONSTRAINT auth_tokens_user_id_fkey TO tokens_user_id_fkey
    """
    create index(:tokens, [:user_id])
    create unique_index(:tokens, [:value])

    rename table(:member_people), to: table(:people)
    rename table(:people), :contact_infos, to: :contact_info
  end
end
