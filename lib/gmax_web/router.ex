defmodule GmaxWeb.Router do
  use GmaxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug(GmaxWeb.Plug.SetCurrentUser, repo: Gmax.Repo)
  end

  scope "/", GmaxWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/privacy", PageController, :privacy
    get "/terms", PageController, :terms
    get "/faq", PageController, :faq
    get "/how-it-works", PageController, :howitworks
    get "/auth/:provider", OAuth2Controller, :index
    get "/auth/:provider/callback", OAuth2Controller, :callback
  end

  scope "/api", GmaxWeb do
    pipe_through :api

    get "/users/status", Api.UserController, :status

    get "/sheets", Api.SheetController, :index
    get "/sheets/:id/headers", Api.SheetController, :headers
    get "/sheets/:id/values", Api.SheetController, :values

    post "/drafts/send", Api.DraftController, :send
    post "/webhooks/gmail/sub", Api.WebhookController, :gmail_sub
  end
end
