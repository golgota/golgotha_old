defmodule ChurchifyWeb.PageController do
  use ChurchifyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
