defmodule Gmax.Repo.Migrations.AddHdFieldToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:hd, :string)
    end
  end
end
