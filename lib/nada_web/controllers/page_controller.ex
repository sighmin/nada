defmodule NadaWeb.PageController do
  use NadaWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html", hide_navigation: true)
  end
end
