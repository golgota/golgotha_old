defmodule Churchify.Web.Router do
  use Churchify.Web, :router

  alias Churchify.Web.AuthPlug
  alias Churchify.Web.ForceAuthPlug

  if Mix.env == :dev do
    forward "/emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug AuthPlug
  end

  pipeline :force_auth do
    plug ForceAuthPlug
  end

  scope "/", Churchify.Web do
    pipe_through :browser

    get "/", PageController, :index

    resources "/sessions", SessionController,
      only: [:new, :create, :delete, :show]
  end

  scope "/", Churchify.Web do
    pipe_through [:browser, :force_auth]

    resources "/users", UserController
  end
end
