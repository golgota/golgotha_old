defmodule Churchify.Repo.Migrations.CreateChurchify.Member.Person do
  use Ecto.Migration

  def change do
    create table(:member_people) do
      add :name, :string
      add :gender, :string
      add :birth_info, :map
      add :civil_info, :map
      add :professional_info, :map
      add :church_info, :map
      add :contact_infos, :map
      add :address_info, :map

      timestamps()
    end

  end
end
