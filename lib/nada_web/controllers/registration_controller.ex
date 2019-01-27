defmodule NadaWeb.RegistrationController do
  use NadaWeb, :controller
  alias Nada.{User, Email, Mailer}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{ "user" => user_params }) do
    #user_params |> IO.inspect()
    # upload image to S3

    # add user map to Agent
    user = User.new(user_params)

    # email confirmation
    user
    |> Email.confirm_email
    |> Mailer.deliver_now

    redirect(conn, to: Routes.registration_path(conn, :confirm))
  end

  def confirm(conn, _params) do
    render(conn, "confirm.html")
  end

  def complete(conn, _params) do
    render(conn, "complete.html")
  end
end
