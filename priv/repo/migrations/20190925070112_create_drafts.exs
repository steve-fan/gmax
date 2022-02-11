defmodule Gmax.Repo.Migrations.CreateDrafts do
  use Ecto.Migration

  def change do
    create table(:drafts) do
      add :user_id, :integer, null: false
      add :message, :text
      add :sheet_values, :text
      add :email_field, :text
      add :to, :text
      add :to_count, :integer, default: 0
      add :original_to, :text

      timestamps()
    end
  end
end
