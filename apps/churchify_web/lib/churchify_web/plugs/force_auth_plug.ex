defmodule Churchify.Web.ForceAuthPlug do
  use Phoenix.Controller
  import Churchify.Web.Gettext
  alias Churchify.Web.Router.Helpers

  def init(_), do: nil

  def call(%{assigns: %{current_user: user}} = conn, _) when user != nil do
    conn
  end
  def call(conn, _) do
    conn
    |> put_flash(:error, gettext("You cannot access this page."))
    |> redirect(to: Helpers.page_path(conn, :index))
    |> halt
  end
end
