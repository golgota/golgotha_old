defmodule Churchify.Web.PageController do
  use Churchify.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
