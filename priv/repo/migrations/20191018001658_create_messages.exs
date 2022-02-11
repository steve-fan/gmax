defmodule Gmax.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :msg_id, :string, null: false
      add :thread_id, :string
      add :user_id, :integer, null: false
      timestamps()
    end

    create index(:messages, [:user_id])
  end
end
