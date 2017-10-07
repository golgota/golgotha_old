defmodule ChurchifyWeb.PageControllerTest do
  use ChurchifyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Get Right Church!"
  end
end
