defmodule Gmax.Jason.Tuple do
  defimpl Jason.Encoder, for: Tuple do
    def encode(value, opts) do
      value
      |> Tuple.to_list()
      |> Jason.Encode.list(opts)
    end
  end
end
