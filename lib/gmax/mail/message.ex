defmodule Gmax.Mail.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :msg_id, :string
    field :thread_id, :string
    field :user_id, :integer
    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:msg_id, :thread_id, :user_id])
    |> validate_required([:msg_id, :user_id])
    |> unique_constraint(:msg_id)
  end
end
