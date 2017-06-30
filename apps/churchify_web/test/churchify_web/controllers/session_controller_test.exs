defmodule Churchify.Web.SessionControllerTest do
  use Churchify.Web.ConnCase

  alias Churchify.Auth

  @create_attrs %{email: "kelvin.stinghen@gmail.com"}

  def fixture(:user) do
    {:ok, user} = Auth.create_user(@create_attrs)
    user
  end

  test "renders form for new sessions", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Sign In"
  end

  test "creates session and sends token", %{conn: conn} do
    fixture(:user)
    conn = post conn, session_path(conn, :create), session: @create_attrs

    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) =~
      "We have sent you a link for login to your email."
  end

  @tag user: true
  test "deletes chosen session", %{conn: conn} do
    conn = delete conn, session_path(conn, :delete, 0)
    assert redirected_to(conn) == page_path(conn, :index)
    assert get_flash(conn, :info) =~ "You signed out successfully."
  end
end
