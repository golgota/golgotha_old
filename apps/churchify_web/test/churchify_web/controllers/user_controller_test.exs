defmodule ChurchifyWeb.UserControllerTest do
  use ChurchifyWeb.ConnCase

  @moduletag user: true

  @create_attrs %{email: "kelvin.stinghen@gmail.com"}
  @update_attrs %{email: "ju.andrade@gmail.com"}
  @invalid_attrs %{email: nil}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Users"
  end

  test "renders form for new users", %{conn: conn} do
    conn = get conn, user_path(conn, :new)
    assert html_response(conn, 200) =~ "New User"
  end

  test "creates user and redirects to edit when data is valid", %{conn: conn} do
    resp = post conn, user_path(conn, :create), user: @create_attrs

    assert %{id: id} = redirected_params(resp)
    assert redirected_to(resp) == user_path(conn, :edit, id)

    resp = get conn, user_path(conn, :edit, id)
    assert html_response(resp, 200) =~ "Edit User"
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New User"
  end

  test "renders form for editing chosen user", %{conn: conn} do
    user = insert(:user)
    conn = get conn, user_path(conn, :edit, user)
    assert html_response(conn, 200) =~ "Edit User"
  end

  test "updates chosen user and redirects when data is valid", %{conn: conn} do
    user = insert(:user)
    resp = put conn, user_path(conn, :update, user), user: @update_attrs
    assert redirected_to(resp) == user_path(conn, :edit, user)

    resp = get conn, user_path(conn, :edit, user)
    assert html_response(resp, 200) =~ "ju.andrade@gmail.com"
  end

  test "does not update chosen user and renders errors when data is invalid", %{conn: conn} do
    user = insert(:user)
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit User"
  end

  test "deletes chosen user", %{conn: conn} do
    user = insert(:user)
    resp = delete conn, user_path(conn, :delete, user)
    assert redirected_to(resp) == user_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :edit, user)
    end
  end
end
