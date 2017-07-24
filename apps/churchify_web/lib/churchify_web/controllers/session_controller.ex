defmodule Churchify.Web.SessionController do
  use Churchify.Web, :controller

  alias Churchify.Auth
  alias Churchify.Web.Auth, as: WebAuth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email}}) do
    WebAuth.send_token(email)

    conn
    |> put_flash(:success,
                 gettext("We have sent you a link for login to your email."))
    |> redirect(to: page_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    case Auth.verify_token(id) do
      {:ok, user} ->
        conn
        |> WebAuth.sign_in(user)
        |> put_flash(:success, gettext("You signed in successfully."))
        |> redirect(to: page_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("The sign in token is invalid."))
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> WebAuth.sign_out()
    |> put_flash(:success, gettext("You signed out successfully."))
    |> redirect(to: page_path(conn, :index))
  end
end
