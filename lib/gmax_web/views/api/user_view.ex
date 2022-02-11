defmodule GmaxWeb.Api.UserView do
  use GmaxWeb, :view

  def render("status.json", %{user: user}) do
    %{
      email: user.email,
      authorized: true
    }
  end

  def render("error.json", _) do
    %{
      authorized: false
    }
  end
end
