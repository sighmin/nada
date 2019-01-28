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

  def destroy(conn, %{ "redirect_path" => redirect_path }) do
    conn
      |> delete_session(:authenticated)
      |> redirect(to: redirect_path)
  end

  def destroy(conn, _) do
    conn
      |> delete_session(:authenticated)
      |> redirect(to: Routes.page_path(conn, :index))
  end
end
