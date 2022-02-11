defmodule GmaxWeb.Api.UserControllerTest do
  use GmaxWeb.ConnCase
  alias Gmax.Account

  describe "status/2" do
    @valid_attrs %{
      email: "a@gmail.com",
      name: "Michael Jordan",
      oauth_provider: "google",
      oauth_provider_id: "124131441412",
      access_token: "0l0UDsBIbp5k7dbsBiUp",
      refresh_token: "2cylTcNxL3p0SduZl",
      access_token_expired_at: ~N[2019-09-01 17:00:01]
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} = attrs |> Enum.into(@valid_attrs) |> Account.create_user()
      user
    end
  end
end
