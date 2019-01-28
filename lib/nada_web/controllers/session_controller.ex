defmodule NadaWeb.SessionController do
  use NadaWeb, :controller
  alias Nada.Mapping

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{ "user" => %{ "file" => file } }) do
    user = Mapping.find_by_file(file)
    if user do
      conn
      |> redirect(to: Routes.session_path(conn, :email_found, email: user.email))
    end
    redirect(conn, to: Routes.session_path(conn, :email_found))
  end

  def face_id(conn, _params) do
    render(conn, "face_id.html")
  end

  def email_found(conn, params) do
    conn
    |> assign(:email, params["email"])
    |> render("email_found.html")
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
