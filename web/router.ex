defmodule Spike.Router do
  use Spike.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Spike.Auth, repo: Spike.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Unauthed routes
scope "/", Spike do
    pipe_through :browser # Use the default browser stack

    resources "/session", SessionController, only: [:new, :create, :delete]
    get "/", PageController, :index
    get "/user/new", UserController, :new
    post "/user/new", UserController, :create
  end


  # Authed routes
  scope "/", Spike do
    pipe_through [:browser, :authenticate_user]

    resources "/user", UserController, except: [:new, :create]
    resources "/tasks", TaskController
    get "/lists", ListController, :index
    get "/lists/:date", ListController, :show
    post "/lists/:date", ListController, :create
    delete "/lists/:date", ListController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Spike do
  #   pipe_through :api
  # end
end
