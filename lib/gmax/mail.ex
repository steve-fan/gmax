defmodule Gmax.Mail do
  @moduledoc """
  The Mail context.
  """

  import Ecto.Query, warn: false
  alias Gmax.Repo
  alias Gmax.Mail.{Draft, Message}

  def get_unsend_draft(user_id) do
    query =
      from(d in Draft,
        where: d.to_count > 0,
        where: d.user_id == ^user_id,
        order_by: [asc: d.inserted_at]
      )

    first(query) |> Repo.one()
  end

  @doc """
  Returns the list of drafts.

  ## Examples

      iex> list_drafts()
      [%Draft{}, ...]

  """
  def list_drafts do
    Repo.all(Draft)
  end

  @doc """
  Gets a single draft.

  Raises `Ecto.NoResultsError` if the Draft does not exist.

  ## Examples

      iex> get_draft!(123)
      %Draft{}

      iex> get_draft!(456)
      ** (Ecto.NoResultsError)

  """
  def get_draft!(id), do: Repo.get!(Draft, id)

  @doc """
  Creates a draft.

  ## Examples

      iex> create_draft(%{field: value})
      {:ok, %Draft{}}

      iex> create_draft(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_draft(attrs \\ %{}) do
    %Draft{}
    |> Draft.changeset(attrs)
    |> Draft.set_original_to()
    |> Draft.clean_to_header()
    |> Repo.insert()
  end

  def create_draft(%Gmax.Account.User{} = user, draft_id) do
    case Gmax.Gmail.gmail_users_drafts_get(user, draft_id, format: "raw") do
      {:ok, draft} ->
        create_draft(%{user_id: user.id, message: draft.message.raw})

      {:error, reason} ->
        {:error, Draft.get_draft_error()}
    end
  end

  def create_draft(%Gmax.Account.User{} = user, draft_id, sheet_id, email_field) do
    with {:ok, draft} = Gmax.Gmail.gmail_users_drafts_get(user, draft_id, format: "raw"),
         {_headers, values} = Gmax.Spreadsheet.get_and_parse(user, sheet_id) do
      create_draft(%{
        user_id: user.id,
        message: draft.message,
        sheet_values: values,
        email_field: email_field
      })
    else
      {:error, %{} = env} ->
        {:error, Draft.get_draft_error()}
    end
  end

  @doc """
  Updates a draft.

  ## Examples

      iex> update_draft(draft, %{field: new_value})
      {:ok, %Draft{}}

      iex> update_draft(draft, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_draft(%Draft{} = draft, attrs) do
    draft
    |> Draft.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Draft.

  ## Examples

      iex> delete_draft(draft)
      {:ok, %Draft{}}

      iex> delete_draft(draft)
      {:error, %Ecto.Changeset{}}

  """
  def delete_draft(%Draft{} = draft) do
    Repo.delete(draft)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking draft changes.

  ## Examples

      iex> change_draft(draft)
      %Ecto.Changeset{source: %Draft{}}

  """
  def change_draft(%Draft{} = draft) do
    Draft.changeset(draft, %{})
  end

  def send_count_of_last_24hours(user_id) do
    query =
      from(m in Message, where: m.inserted_at > from_now(-1, "day"), where: m.user_id == ^user_id)

    Repo.aggregate(query, :count, :id)
  end

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
end
