defmodule NadaWeb.Router do
  use NadaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NadaWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/register/confirm", RegistrationController, :confirm
    get "/register/complete", RegistrationController, :complete

    get "/login", SessionController, :new
    get "/login/face", SessionController, :face_id
    get "/login/email", SessionController, :email_found
    get "/login/confirm", SessionController, :confirm

    get "/nothing", NothingController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", NadaWeb do
  #   pipe_through :api
  # end
end
