defmodule Churchify.Web.Auth do
  import Plug.Conn

  alias Churchify.Auth
  alias Churchify.Auth.User

  @doc """
  Signs the user in.
  """
  def sign_in(conn, nil), do: sign_out(conn)
  def sign_in(conn, id) when is_integer(id) do
    sign_in(conn, Auth.get_user!(id))
  end
  def sign_in(conn, %User{} = user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
  end

  @doc """
  Signs the user out.
  """
  def sign_out(conn) do
    conn
    |> assign(:current_user, nil)
    |> put_session(:user_id, nil)
  end
end
