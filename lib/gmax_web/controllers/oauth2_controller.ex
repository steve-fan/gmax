defmodule GmaxWeb.OAuth2Controller do
  use GmaxWeb, :controller

  alias Gmax.Account
  alias Gmax.OAuth2.{Google}

  def index(conn, %{"provider" => provider} = params) do
    redirect(conn, external: authorize_url!(provider, params["email"]))
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = get_token!(provider, code)
    profile = get_user_profile!(provider, client)
    {:ok, current_user} = Account.oauth2_registration(provider, profile, client)

    conn
    |> put_session("_gmax_user:#{current_user.email}", current_user.id)
    |> render("callback.html", user: current_user)
  end

  defp get_token!("google", code), do: Google.get_token!(code: code)
  defp get_token!(_, _), do: raise("No matching provider available")

  defp authorize_url!("google", email) do
    scopes = [
      "email",
      "profile",
      "openid",
      "https://www.googleapis.com/auth/drive.readonly",
      "https://www.googleapis.com/auth/gmail.compose"
    ]

    Google.authorize_url!(
      scope: Enum.join(scopes, " "),
      access_type: "offline",
      login_hint: email,
      prompt: "select_account"
    )
  end

  defp authorize_url!(_, _) do
    raise("No matching provider available")
  end

  defp get_user_profile!("google", client) do
    %{body: profile} =
      OAuth2.Client.get!(client, "https://www.googleapis.com/oauth2/v1/userinfo?alt=json")

    profile
  end

  defp get_user_profile!(_provider, client) do
    raise("No matching provider available")
  end
end
