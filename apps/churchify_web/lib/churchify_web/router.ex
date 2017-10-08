defmodule ChurchifyWeb.Router do
  use ChurchifyWeb, :router

  alias ChurchifyWeb.AuthPlug
  alias ChurchifyWeb.ForceAuthPlug

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

  scope "/", ChurchifyWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/sessions", SessionController,
      only: [:new, :create, :delete, :show]
  end

  scope "/", ChurchifyWeb do
    pipe_through [:browser, :force_auth]

    resources "/people", PersonController
    resources "/users", UserController, except: [:show]
  end
end
