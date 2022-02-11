defmodule GmaxWeb.Api.DraftView do
  use GmaxWeb, :view

  def render("draft.json", %{draft: draft}) do
    %{
      success: true,
      data: %{
        id: draft.id
      }
    }
  end
end
