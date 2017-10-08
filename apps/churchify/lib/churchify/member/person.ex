defmodule Churchify.Member.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.Person


  schema "member_people" do
    field :address_info, :map
    field :birth_info, :map
    field :church_info, :map
    field :civil_info, :map
    field :contact_infos, :map
    field :gender, :string
    field :name, :string
    field :professional_info, :map

    timestamps()
  end

  @doc false
  def changeset(%Person{} = person, attrs) do
    person
    |> cast(attrs, [:name, :gender, :birth_info, :civil_info, :professional_info, :church_info, :contact_infos, :address_info])
    |> validate_required([:name, :gender, :birth_info, :civil_info, :professional_info, :church_info, :contact_infos, :address_info])
  end
end
