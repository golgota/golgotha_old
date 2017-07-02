defmodule Churchify.Web.AuthTest do
  use Churchify.Web.ConnCase

  alias Churchify.Web.Auth

  test "sign_in/2 must assign current user and save him to session", %{conn: conn} do
    conn = Plug.Test.init_test_session(conn, [])
    user = insert(:user)

    resp = Auth.sign_in(conn, user)
    assert resp.assigns[:current_user] == user
    assert get_session(resp, :user_id) == user.id

    resp = Auth.sign_in(conn, user.id)
    assert resp.assigns[:current_user] == user
    assert get_session(resp, :user_id) == user.id
  end
end

