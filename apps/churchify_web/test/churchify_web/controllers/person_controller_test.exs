defmodule ChurchifyWeb.PersonControllerTest do
  use ChurchifyWeb.ConnCase

  alias Churchify.Member

  @moduletag user: true

  @create_attrs %{
    address_info: %{},
    birth_info: %{},
    church_info: %{},
    civil_info: %{},
    contact_infos: %{},
    gender: "some gender",
    name: "some name",
    professional_info: %{}
  }
  @update_attrs %{
    address_info: %{},
    birth_info: %{},
    church_info: %{},
    civil_info: %{},
    contact_infos: %{},
    gender: "some updated gender",
    name: "some updated name",
    professional_info: %{}
  }
  @invalid_attrs %{
    address_info: nil,
    birth_info: nil,
    church_info: nil,
    civil_info: nil,
    contact_infos: nil,
    gender: nil,
    name: nil,
    professional_info: nil
  }

  def fixture(:person) do
    {:ok, person} = Member.create_person(@create_attrs)
    person
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, person_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing People"
  end

  test "renders form for new people", %{conn: conn} do
    conn = get conn, person_path(conn, :new)
    assert html_response(conn, 200) =~ "New Person"
  end

  test "creates person and redirects to edit when data is valid", %{conn: conn} do
    resp = post conn, person_path(conn, :create), person: @create_attrs

    assert %{id: id} = redirected_params(resp)
    assert redirected_to(resp) == person_path(resp, :edit, id)

    resp = get conn, person_path(conn, :edit, id)
    assert html_response(resp, 200) =~ "Edit Person"
  end

  test "does not create person and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, person_path(conn, :create), person: @invalid_attrs
    assert html_response(conn, 200) =~ "New Person"
  end

  test "renders form for editing chosen person", %{conn: conn} do
    person = fixture(:person)
    conn = get conn, person_path(conn, :edit, person)
    assert html_response(conn, 200) =~ "Edit Person"
  end

  test "updates chosen person and redirects when data is valid", %{conn: conn} do
    person = fixture(:person)
    resp = put conn, person_path(conn, :update, person), person: @update_attrs
    assert redirected_to(resp) == person_path(resp, :edit, person)

    resp = get conn, person_path(conn, :edit, person)
    assert html_response(resp, 200) =~ "some updated gender"
  end

  test "does not update chosen person and renders errors when data is invalid", %{conn: conn} do
    person = fixture(:person)
    conn = put conn, person_path(conn, :update, person), person: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Person"
  end

  test "deletes chosen person", %{conn: conn} do
    person = fixture(:person)
    resp = delete conn, person_path(conn, :delete, person)
    assert redirected_to(resp) == person_path(resp, :index)
    assert_error_sent 404, fn ->
      get conn, person_path(conn, :edit, person)
    end
  end
end
