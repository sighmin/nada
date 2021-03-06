defmodule NadaWeb.Router do
  use NadaWeb, :router

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :authenticate do
    plug :set_authenticated
  end

  pipeline :assign_flash do
    plug :capture_flash
  end

  pipeline :authentication_required do
    plug NadaWeb.AuthenticationPlug
  end

  scope "/", NadaWeb do
    pipe_through [:browser, :authenticate, :assign_flash]

    get "/", PageController, :index

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/register/confirm", RegistrationController, :confirm
    get "/register/complete/:token", RegistrationController, :complete

    get "/login", SessionController, :new
    get "/login/email", SessionController, :email_found
    post "/login/email", SessionController, :autocomplete_email
    get "/login/confirm", SessionController, :confirm
    post "/login", SessionController, :create
    get "/login/complete/:otp", SessionController, :complete
    get "/logout", SessionController, :destroy
  end

  scope "/", NadaWeb do
    pipe_through [:browser, :authenticate, :authentication_required]

    get "/nothing", NothingController, :index
  end

  defp set_authenticated(conn, _) do
    authenticated = get_session(conn, :authenticated)
    assign(conn, :authenicated, authenticated)
  end

  defp capture_flash(conn, _) do
    conn
    |> put_flash(:info, conn.query_params["info"])
    |> put_flash(:error, conn.query_params["error"])
  end
end
