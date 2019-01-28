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

  pipeline :authentication_required do
    plug NadaWeb.AuthenticationPlug
  end

  scope "/", NadaWeb do
    pipe_through [:browser, :authenticate]

    get "/", PageController, :index

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/register/confirm", RegistrationController, :confirm
    get "/register/complete/:token", RegistrationController, :complete

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/login/face", SessionController, :face_id
    get "/login/email", SessionController, :email_found
    get "/login/confirm", SessionController, :confirm
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
end
