defmodule Churchify.Web.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import Churchify.Web.Router.Helpers

      import Churchify.Factory

      # The default endpoint for testing
      @endpoint Churchify.Web.Endpoint
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Churchify.Repo)
    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Churchify.Repo, {:shared, self()})
    end

    conn =
      Phoenix.ConnTest.build_conn()
      |> sign_in(tags[:user])

    {:ok, conn: conn}
  end

  alias Churchify.Auth

  def sign_in(conn, nil), do: conn
  def sign_in(conn, true) do
    {:ok, user} = Auth.create_user(%{email: "test@user.com"})
    Plug.Conn.assign(conn, :current_user, user)
  end
end
