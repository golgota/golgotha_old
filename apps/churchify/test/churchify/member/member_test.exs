defmodule Churchify.MemberTest do
  use Churchify.DataCase

  alias Churchify.Member

  describe "people" do
    alias Churchify.Member.Person

    @valid_attrs %{address_info: %{}, birth_info: %{}, church_info: %{}, civil_info: %{}, contact_infos: %{}, gender: "some gender", name: "some name", professional_info: %{}}
    @update_attrs %{address_info: %{}, birth_info: %{}, church_info: %{}, civil_info: %{}, contact_infos: %{}, gender: "some updated gender", name: "some updated name", professional_info: %{}}
    @invalid_attrs %{address_info: nil, birth_info: nil, church_info: nil, civil_info: nil, contact_infos: nil, gender: nil, name: nil, professional_info: nil}

    def person_fixture(attrs \\ %{}) do
      {:ok, person} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Member.create_person()

      person
    end

    test "list_people/0 returns all people" do
      person = person_fixture()
      assert Member.list_people() == [person]
    end

    test "get_person!/1 returns the person with given id" do
      person = person_fixture()
      assert Member.get_person!(person.id) == person
    end

    test "create_person/1 with valid data creates a person" do
      assert {:ok, %Person{} = person} = Member.create_person(@valid_attrs)
      assert person.address_info == %{}
      assert person.birth_info == %{}
      assert person.church_info == %{}
      assert person.civil_info == %{}
      assert person.contact_infos == %{}
      assert person.gender == "some gender"
      assert person.name == "some name"
      assert person.professional_info == %{}
    end

    test "create_person/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Member.create_person(@invalid_attrs)
    end

    test "update_person/2 with valid data updates the person" do
      person = person_fixture()
      assert {:ok, person} = Member.update_person(person, @update_attrs)
      assert %Person{} = person
      assert person.address_info == %{}
      assert person.birth_info == %{}
      assert person.church_info == %{}
      assert person.civil_info == %{}
      assert person.contact_infos == %{}
      assert person.gender == "some updated gender"
      assert person.name == "some updated name"
      assert person.professional_info == %{}
    end

    test "update_person/2 with invalid data returns error changeset" do
      person = person_fixture()
      assert {:error, %Ecto.Changeset{}} = Member.update_person(person, @invalid_attrs)
      assert person == Member.get_person!(person.id)
    end

    test "delete_person/1 deletes the person" do
      person = person_fixture()
      assert {:ok, %Person{}} = Member.delete_person(person)
      assert_raise Ecto.NoResultsError, fn -> Member.get_person!(person.id) end
    end

    test "change_person/1 returns a person changeset" do
      person = person_fixture()
      assert %Ecto.Changeset{} = Member.change_person(person)
    end
  end
end
