defmodule Spike.Router do
  use Spike.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Spike.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Unauthed routes
  scope "/", Spike do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end


  # Authed routes
  scope "/", Spike do
    pipe_through [:browser, :authenticate_user]

    resources "/user", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Spike do
  #   pipe_through :api
  # end
end
