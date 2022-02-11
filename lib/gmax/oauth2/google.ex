defmodule Gmax.OAuth2.Google do
  use OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode

  defp config do
    [
      strategy: __MODULE__,
      site: "https://accounts.google.com/",
      authorize_url: "https://accounts.google.com/o/oauth2/auth",
      token_url: "https://accounts.google.com/o/oauth2/token"
    ]
  end

  # Public API

  def client do
    Application.get_env(:gmax, Google)
    |> Keyword.merge(config())
    |> OAuth2.Client.new()
  end

  # Refreshing an access token
  def refresh_client(refresh_token) do
    Application.get_env(:gmax, Google)
    |> Keyword.merge(config())
    |> Keyword.merge(
      strategy: OAuth2.Strategy.Refresh,
      params: %{"refresh_token" => refresh_token}
    )
    |> OAuth2.Client.new()
  end

  def authorize_url!(params \\ []) do
    OAuth2.Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    OAuth2.Client.get_token!(
      client(),
      Keyword.merge(params, client_secret: client().client_secret),
      headers
    )
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
