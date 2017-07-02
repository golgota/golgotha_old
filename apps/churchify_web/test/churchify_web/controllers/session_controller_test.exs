defmodule Churchify.Web.SessionControllerTest do
  use Churchify.Web.ConnCase

  @create_attrs %{email: "kelvin.stinghen@gmail.com"}

  test "renders form for new sessions", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Sign In"
  end

  test "creates session and sends token", %{conn: conn} do
    insert(:user, @create_attrs)
    conn = post conn, session_path(conn, :create), session: @create_attrs

    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) =~
      "We have sent you a link for login to your email."
  end

  test "verifies the session token", %{conn: conn} do
    token = insert(:token)
    resp = get conn, session_path(conn, :show, token.value)

    assert redirected_to(resp) == page_path(conn, :index)
    assert get_flash(resp, :info) =~ "You signed in successfully."

    resp = get conn, session_path(conn, :show, token.value)

    assert redirected_to(resp) == session_path(conn, :new)
    assert get_flash(resp, :error) =~ "The sign in token is invalid."
  end

  @tag user: true
  test "deletes chosen session", %{conn: conn} do
    conn = delete conn, session_path(conn, :delete, 0)
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) =~ "You signed out successfully."
  end
end
