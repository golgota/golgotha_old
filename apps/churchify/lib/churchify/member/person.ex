defmodule Churchify.Member.Person do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.Person
  alias Churchify.Member.AddressInfo
  alias Churchify.Member.BirthInfo
  alias Churchify.Member.ChurchInfo
  alias Churchify.Member.CivilInfo
  alias Churchify.Member.ContactInfo
  alias Churchify.Member.ProfessionalInfo

  schema "member_people" do
    field :name, :string
    field :gender, :string

    embeds_one :address_info, AddressInfo
    embeds_one :birth_info, BirthInfo
    embeds_one :church_info, ChurchInfo
    embeds_one :civil_info, CivilInfo
    embeds_one :contact_info, ContactInfo
    embeds_one :professional_info, ProfessionalInfo

    timestamps()
  end

  @doc false
  def changeset(%Person{} = person, attrs) do
    person
    |> cast(attrs, [:name, :gender])
    |> cast_embed(:address_info)
    |> cast_embed(:birth_info)
    |> cast_embed(:church_info)
    |> cast_embed(:civil_info)
    |> cast_embed(:contact_info)
    |> cast_embed(:professional_info)
    |> validate_required([:name, :gender])
  end
end

defmodule Churchify.Member.AddressInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.AddressInfo

  embedded_schema do
    field :number, :string
    field :street, :string
    field :neighborhood, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :more_info, :string
    field :zip_code, :string
  end

  @doc false
  def changeset(%AddressInfo{} = address_info, attrs) do
    address_info
    |> cast(attrs, [:number, :street, :neighborhood, :city, :state, :country, :more_info, :zip_code])
  end
end

defmodule Churchify.Member.BirthInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.BirthInfo

  embedded_schema do
    field :date, :date
    field :city, :string
    field :state, :string
    field :country, :string
  end

  @doc false
  def changeset(%BirthInfo{} = birth_info, attrs) do
    birth_info
    |> cast(attrs, [:date, :city, :state, :country])
  end
end

defmodule Churchify.Member.ChurchInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.ChurchInfo

  embedded_schema do
    field :baptism_date, :date
    field :conversion_date, :date
  end

  @doc false
  def changeset(%ChurchInfo{} = church_info, attrs) do
    church_info
    |> cast(attrs, [:baptism_date, :conversion_date])
  end
end

defmodule Churchify.Member.CivilInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.Person
  alias Churchify.Member.CivilInfo

  embedded_schema do
    field :status, :string

    belongs_to :partner, Person
  end

  @doc false
  def changeset(%CivilInfo{} = civil_info, attrs) do
    civil_info
    |> cast(attrs, [:status, :partner_id])
  end
end

defmodule Churchify.Member.ContactInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.ContactInfo

  embedded_schema do
    field :email, :string
    field :phone, :string
    field :cellphone, :string
  end

  @doc false
  def changeset(%ContactInfo{} = contact_info, attrs) do
    contact_info
    |> cast(attrs, [:email, :phone, :cellphone])
  end
end

defmodule Churchify.Member.ProfessionalInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Churchify.Member.ProfessionalInfo

  embedded_schema do
    field :profession, :string
  end

  @doc false
  def changeset(%ProfessionalInfo{} = professional_info, attrs) do
    professional_info
    |> cast(attrs, [:profession])
  end
end
