defmodule GmaxWeb.Api.SheetController do
  use GmaxWeb, :controller
  alias Gmax.Account
  alias GoogleApi.Drive.V3.Api, as: DriveApi
  alias GmaxWeb.Plug.Authorize

  plug(Authorize, "access" when action in [:index, :headers, :values])

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  @doc """
  Return an list of spreadsheets.
  """
  def index(conn, _params, current_user) do
    sheets = Gmax.Drive.list_google_sheet(current_user)

    conn
    |> put_resp_content_type("application/json")
    |> render("sheets.json", sheets: sheets)
  end

  @doc """
  Returns the headers of the sheet of the given id.
  """
  def headers(conn, %{"id" => id} = _params, current_user) do
    headers = Gmax.Spreadsheet.get_first_sheet_headers(current_user, id)

    conn
    |> put_resp_content_type("application/json")
    |> render("headers.json", headers: headers)
  end

  @doc """
  Returns a list of emails

  params:
    email: String.t(), required, email address
    field: String.t(), required, spreadsheet id
    id: String.t(), required, column name
  """

  def values(conn, %{"id" => id, "field" => field}, current_user) do
    values = Gmax.Spreadsheet.get_first_sheet_values_by_column(current_user, id, field)

    conn
    |> put_resp_content_type("application/json")
    |> render("column.json", values: values)
  end
end
