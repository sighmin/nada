defmodule NadaWeb.PageController do
  use NadaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", hide_navigation: true)
  end
end
