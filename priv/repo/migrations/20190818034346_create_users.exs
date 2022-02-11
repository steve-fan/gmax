defmodule Gmax.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string, null: false
      add :avatar_url, :string
      add :oauth_provider, :string
      add :oauth_provider_id, :string
      add :access_token, :string
      add :refresh_token, :string
      add :access_token_expired_at, :naive_datetime

      timestamps()
    end
  end
end
