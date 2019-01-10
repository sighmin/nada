defmodule NadaWeb.NothingController do
  use NadaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
