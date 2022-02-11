defmodule Gmax.Ecto.Json do
  @behaviour Ecto.Type
  def type, do: :string

  def cast(str) when is_binary(str) do
    Jason.decode(str)
  end

  def cast(%{} = map) do
    {:ok, map}
  end

  def cast(l) when is_list(l) do
    {:ok, l}
  end

  def cast(_), do: :error

  # load data from database
  def load(data) when is_binary(data) do
    Jason.decode(data)
  end

  # dumping data to the database
  def dump(json) do
    Jason.encode(json)
  end
end
