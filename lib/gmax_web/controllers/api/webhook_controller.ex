defmodule GmaxWeb.Api.WebhookController do
  use GmaxWeb, :controller
  require Logger

  def gmail_sub(conn, params) do
    Logger.info(inspect(params))
    text(conn, "OK")
  end
end
