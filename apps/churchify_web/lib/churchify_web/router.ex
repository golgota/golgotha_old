defmodule Churchify.Web.Router do
  use Churchify.Web, :router

  alias Churchify.Web.AuthPlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug AuthPlug
  end

  scope "/", Churchify.Web do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController
    resources "/sessions", SessionController,
      only: [:new, :create, :delete, :show]
  end
end
