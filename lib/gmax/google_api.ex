defmodule Gmax.GoogleApi do
  def new_connection(token) when is_binary(token) do
    middleware = [
      {Tesla.Middleware.Headers,
       [{"authorization", "Bearer #{token}"}, {"Content-Type", "application/json"}]}
    ]

    request_opts = Application.get_env(:gmax, Gmax.GoogleApi)[:request_opts]
    adapter = {Tesla.Adapter.Hackney, request_opts}
    Tesla.client(middleware, adapter)
  end

  def new_connection(%{
        access_token: access_token,
        access_token_expired_at: expires_at,
        refresh_token: refresh_token
      }) do
    now = NaiveDateTime.utc_now()
    diff = NaiveDateTime.diff(expires_at, now)

    # access_token 有效时间小于 10 分钟，重新获取 access_token
    if diff < 5 * 60 do
      client =
        Gmax.OAuth2.Google.refresh_client(refresh_token)
        |> OAuth2.Client.get_token!()

      new_connection(client.token.access_token)
    else
      new_connection(access_token)
    end
  end
end
