defmodule Gmax.Repo.Migrations.AddExtensionKeyToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:extension_key, :string)
    end
  end
end
