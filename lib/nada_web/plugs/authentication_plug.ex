defmodule NadaWeb.AuthenticationPlug do
  @behaviour Plug

  import Plug.Conn, only: [halt: 1, get_session: 2]
  import Phoenix.Controller, only: [redirect: 2]

  alias NadaWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _default) do
    if get_session(conn, :authenticated) do
      conn
    else
      conn
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    end
  end
end
