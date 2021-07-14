defmodule Web.Router do
  use Web, :router

  import Web.Plugs.Auth, only: [authenticate_api_user: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Web.Plugs.Auth
  end

  ### WARNING: routing order matters. ###

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: Web.Telemetry
    end
  end

  scope "/api/login", Web do
    pipe_through :api

    post "/", AuthController, :login
  end

  # Api endpoints.
  scope "/api", Web do
    pipe_through [:api, :authenticate_api_user]

    get "/test", TestController, :index
  end

  # Generic enpoint for static app.
  scope "/*page", Web do
    pipe_through :browser

    get "/", PageController, :index
  end
end
