defmodule NadaWeb.SessionController do
  use NadaWeb, :controller
  alias Nada.{Sessions,Mapping}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def autocomplete_email(conn, %{ "user" => %{ "file" => file } }) do
    # new implementation - make it work!
    #user = Sessions.find_user_from_face(file)

    # old implementation - remove!
    user = Mapping.find_by_file(file)

    if user do
      conn
      |> redirect(to: Routes.session_path(conn, :email_found, email: user.email))
    else
      redirect(conn, to: Routes.session_path(conn, :email_found))
    end
  end

  def email_found(conn, params) do
    conn
    |> assign(:email, params["email"])
    |> render("email_found.html")
  end

  def create(conn, %{ "user" => %{ "email" => email } }) do
    user = Mapping.find_by_email(email)

    if user do
      user
      |> Sessions.identity_challenge

      conn
      |> redirect(to: Routes.session_path(conn, :confirm))
    else
      conn
      |> assign(:email, email)
      |> render("email_found.html")
    end
  end

  def confirm(conn, _params) do
    render(conn, "confirm.html")
  end

  def complete(conn, %{ "otp" => otp }) do
    user = Mapping.find_by_otp(otp)

    if user do
      user
      |> Sessions.complete_login

      conn
      |> put_session(:authenticated, true)
      |> redirect(to: Routes.nothing_path(conn, :index))
    else
      conn
      |> delete_session(:authenticated)
      |> redirect(to: Routes.page_path(conn, :index))
    end
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

  # static routes

  def face_id(conn, _params) do
    render(conn, "face_id.html")
  end
end
