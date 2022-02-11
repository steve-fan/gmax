defmodule GmaxWeb.PageControllerTest do
  use GmaxWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "GMAX"
  end
end
