defmodule NadaWeb.RegistrationController do
  use NadaWeb, :controller
  alias Nada.Registration

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{ "user" => user_params }) do
    Registration.identity_claim(user_params)
    redirect(conn, to: Routes.registration_path(conn, :confirm))
  end

  def confirm(conn, _params) do
    render(conn, "confirm.html")
  end

  def complete(conn, %{ "token" => token }) do
    user = Registration.identity_verification(token)

    if user do
      Registration.complete_registration(user)
      conn
      |> put_session(:authenticated, true)
      |> render("complete.html")
    else
      redirect(conn, to: Routes.page_path(conn, :index))
    end
  end
end
