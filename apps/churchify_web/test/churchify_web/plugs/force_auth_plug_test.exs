defmodule Churchify.Web.ForceAuthPlugTest do
  use Churchify.Web.ConnCase
  alias Churchify.Web.ForceAuthPlug

  test "plug must check for current user assign", %{conn: conn} do
    conn = Plug.Test.init_test_session(conn, [])
    resp =
      conn
      |> fetch_flash()
      |> ForceAuthPlug.call(nil)
    assert resp.halted
    assert get_flash(resp, :error) == "You cannot access this page."

    resp =
      conn
      |> fetch_flash()
      |> Plug.Conn.assign(:current_user, insert(:user))
      |> ForceAuthPlug.call(nil)
    refute resp.halted
  end
end
