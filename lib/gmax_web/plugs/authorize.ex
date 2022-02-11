defmodule GmaxWeb.Plug.Authorize do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> send_resp(:unauthorized, "")
      |> halt()
    end
  end
end
