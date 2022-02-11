defmodule Gmax.Ecto.MailMessage do
  @behaviour Ecto.Type
  def type, do: :string

  def cast(str) when is_binary(str) do
    message = Base.url_decode64!(str) |> Mail.Parsers.RFC2822.parse()
    {:ok, message}
  end

  def cast(%Mail.Message{} = message) do
    {:ok, message}
  end

  def cast(%GoogleApi.Gmail.V1.Model.Message{} = message) do
    message = message.raw |> Base.url_decode64!() |> Mail.Parsers.RFC2822.parse()
    {:ok, message}
  end

  def cast(_), do: :error

  # loading data from Database
  def load(data) when is_binary(data) do
    message = Base.url_decode64!(data) |> Mail.Parsers.RFC2822.parse()
    {:ok, message}
  end

  # dumping data to the database
  def dump(%Mail.Message{} = message) do
    {:ok, Mail.Renderers.RFC2822.render(message) |> Base.url_encode64()}
  end
end
