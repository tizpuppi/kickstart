defmodule Kickstart.Router do
  use Kickstart.Web, :router

  require Ueberauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", Kickstart do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController

    # resources means:
    # user_path  GET     /users           HelloPhoenix.UserController :index
    # user_path  GET     /users/:id/edit  HelloPhoenix.UserController :edit
    # user_path  GET     /users/new       HelloPhoenix.UserController :new
    # user_path  GET     /users/:id       HelloPhoenix.UserController :show
    # user_path  POST    /users           HelloPhoenix.UserController :create
    # user_path  PATCH   /users/:id       HelloPhoenix.UserController :update
    #            PUT     /users/:id       HelloPhoenix.UserController :update
    # user_path  DELETE  /users/:id       HelloPhoenix.UserController :delete

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
  end

  scope "/auth", Kickstart do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Kickstart do
  #   pipe_through :api
  # end
end
