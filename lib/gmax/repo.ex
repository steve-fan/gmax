defmodule Gmax.Repo do
  use Ecto.Repo,
    otp_app: :gmax,
    adapter: Ecto.Adapters.Postgres
end
