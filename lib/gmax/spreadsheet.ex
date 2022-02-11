defmodule Gmax.Spreadsheet do
  alias GoogleApi.Sheets.V4.Api, as: SheetsApi
  alias Gmax.Account.User

  def get_and_parse(user, spreadsheet_id) do
    Gmax.GoogleApi.new_connection(user)
    |> get_first_sheet_values(spreadsheet_id)
    |> values_to_map()
  end

  def get_first_sheet_headers(user, spreadsheet_id) do
    conn = Gmax.GoogleApi.new_connection(user)
    {:ok, spreadsheet} = SheetsApi.Spreadsheets.sheets_spreadsheets_get(conn, spreadsheet_id)
    [first_sheet | _] = spreadsheet.sheets

    {:ok, value_range} =
      SheetsApi.Spreadsheets.sheets_spreadsheets_values_get(
        conn,
        spreadsheet_id,
        "A1:Z1"
      )

    List.first(value_range.values)
  end

  def get_first_sheet_values(conn, spreadsheet_id) do
    {:ok, spreadsheet} = SheetsApi.Spreadsheets.sheets_spreadsheets_get(conn, spreadsheet_id)
    [first_sheet | _] = spreadsheet.sheets
    title = first_sheet.properties.title

    {:ok, value_range} =
      SheetsApi.Spreadsheets.sheets_spreadsheets_values_get(conn, spreadsheet_id, title)

    value_range.values
  end

  def get_first_sheet_values_by_column(user, spreadsheet_id, column) do
    conn = Gmax.GoogleApi.new_connection(user)
    [headers | rows] = get_first_sheet_values(conn, spreadsheet_id)

    case Enum.find_index(headers, fn title -> title == column end) do
      nil ->
        nil

      index ->
        rows |> Enum.map(&Enum.at(&1, index))
    end
  end

  @doc """
  Transform sheet values(List) into map(Map).
  Returns a header list and all other values as map.
  """
  def values_to_map(values) do
    [headers | rows] = values

    items =
      rows
      |> Enum.map(fn row ->
        Enum.zip(headers, row) |> Enum.into(%{})
      end)

    {headers, items}
  end
end
