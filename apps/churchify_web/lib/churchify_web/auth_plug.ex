defmodule Churchify.Web.AuthPlug do
  alias Churchify.Web.Auth

  def init(_), do: nil

  def call(%{assigns: %{current_user: user}} = conn, _) when user != nil do
    conn
  end
  def call(conn, _) do
    Auth.sign_in(conn, Plug.Conn.get_session(conn, :user_id))
  end
end
