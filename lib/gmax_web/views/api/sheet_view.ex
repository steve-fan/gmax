defmodule GmaxWeb.Api.SheetView do
  use GmaxWeb, :view

  def render("sheets.json", %{sheets: sheets}) do
    %{
      sheets: Enum.map(sheets, fn s -> %{id: s.id, name: s.name, text: s.name} end)
    }
  end

  def render("headers.json", %{headers: headers}) do
    %{
      headers: Enum.with_index(headers) |> Enum.map(fn {h, index} -> %{id: index, text: h} end)
    }
  end

  def render("column.json", %{values: values}) do
    %{
      values: values
    }
  end
end
