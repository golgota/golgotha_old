defmodule ChurchifyWeb.Auth do
  import Plug.Conn

  alias Churchify.Auth
  alias Churchify.Auth.Token
  alias Churchify.Auth.User
  alias ChurchifyWeb.AuthEmail
  alias ChurchifyWeb.Mailer

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

  @doc """
  Sends a new magic login token to the user or email.
  """
  def send_token(nil), do: {:error, :not_found}
  def send_token(email) when is_bitstring(email) do
    email
    |> Auth.get_user_by_email!()
    |> send_token()
  end
  def send_token(user) do
    user
    |> Auth.create_token()
    |> do_send_token(user)
  end

  defp do_send_token({:ok, %Token{} = token}, user) do
    token
    |> AuthEmail.session_link()
    |> Mailer.deliver_now()

    {:ok, user}
  end
end
