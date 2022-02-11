defmodule GmaxWeb.Api.DraftController do
  use GmaxWeb, :controller
  alias Gmax.{Repo, Account}
  alias GmaxWeb.Plug.Authorize
  alias GmaxWeb.ErrorView

  plug(Authorize, "access" when action in [:send])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def send(conn, %{"draftId" => draft_id, "sheetId" => sheet_id, "emailField" => email_field}, me) do
    case Gmax.Mail.create_draft(me, draft_id, sheet_id, email_field) do
      {:ok, draft} ->
        spawn(fn -> Gmax.Gmail.gmail_users_drafts_delete(me, draft_id) end)
        Gmax.Delivery.start_sender_if_needed(me)
        render(conn, "draft.json", draft: draft)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "unprocessable_entity.json", changeset: changeset)
    end
  end

  def send(conn, %{"draftId" => draft_id}, me) do
    case Gmax.Mail.create_draft(me, draft_id) do
      {:ok, draft} ->
        spawn(fn -> Gmax.Gmail.gmail_users_drafts_delete(me, draft_id) end)
        Gmax.Delivery.start_sender_if_needed(me)
        render(conn, "draft.json", draft: draft)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "unprocessable_entity.json", changeset: changeset)
    end
  end
end
