defmodule Gmax.Mail.Draft do
  use Ecto.Schema
  import Ecto.Changeset
  alias Gmax.Ecto.{Json, MailMessage}

  schema "drafts" do
    field :email_field, :string
    field :original_to, Json
    field :message, MailMessage
    field :sheet_values, Json
    field :to, Json
    field :to_count, :integer, default: 0
    field :user_id, :integer

    timestamps()
  end

  @required_fields ~w(user_id message)a
  @optional_fields ~w(sheet_values email_field to original_to)a

  @doc false
  def changeset(draft, attrs) do
    draft
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> set_to()
    |> set_to_count()
  end

  def get_draft_error() do
    %Ecto.Changeset{}
    |> add_error(:base, "get user draft error!")
  end

  def set_original_to(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{message: message}} ->
        put_change(changeset, :original_to, Mail.get_to(message))

      _ ->
        changeset
    end
  end

  def clean_to_header(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{message: message}} ->
        message = Mail.Message.put_header(message, "to", [])
        put_change(changeset, :message, message)

      _ ->
        changeset
    end
  end

  defp set_to(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{message: message}} ->
        put_change(changeset, :to, Mail.get_to(message))

      _ ->
        changeset
    end
  end

  defp set_to_count(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{to: to}} ->
        put_change(changeset, :to_count, length(to))

      _ ->
        changeset
    end
  end
end
