defmodule Gmax.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :access_token, :string
    field :access_token_expired_at, :naive_datetime
    field :avatar_url, :string
    field :email, :string
    field :name, :string
    field :oauth_provider, :string
    field :oauth_provider_id, :string
    field :refresh_token, :string
    field :extension_key, :string
    field :hd, :string

    timestamps()
  end

  @required_fields ~w(name email oauth_provider oauth_provider_id)a
  @optional_fields ~w(access_token refresh_token access_token_expired_at avatar_url extension_key hd)a

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end

  def access_token_expired?(%__MODULE__{} = user) do
    seconds =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.diff(user.access_token_expired_at)

    seconds > -60
  end
end
