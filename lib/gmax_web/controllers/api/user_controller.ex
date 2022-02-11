defmodule GmaxWeb.Api.UserController do
  use GmaxWeb, :controller

  alias Gmax.Account

  def status(conn, _params) do
    current_user = conn.assigns.current_user

    if current_user do
      try do
        case Gmax.Gmail.gmail_users_get_profile(current_user) do
          {:ok, profile} ->
            render(conn, "status.json", user: current_user)

          {:error, _env} ->
            conn |> put_status(:unauthorized) |> render("error.json")
        end
      rescue
        OAuth2.Error ->
          conn |> put_status(:unauthorized) |> render("error.json")
      end
    else
      conn |> put_status(:unauthorized) |> render("error.json")
    end
  end
end
