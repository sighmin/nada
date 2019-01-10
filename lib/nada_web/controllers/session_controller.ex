defmodule NadaWeb.SessionController do
  use NadaWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def face_id(conn, _params) do
    render(conn, "face_id.html")
  end

  def email_found(conn, _params) do
    render(conn, "email_found.html")
  end

  def confirm(conn, _params) do
    render(conn, "confirm.html")
  end
end
