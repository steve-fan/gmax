defmodule Gmax.Gmail do
  alias GoogleApi.Gmail.V1.Api.Users, as: GmailApi

  def gmail_users_get_profile(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_get_profile(conn, "me", optional_params, opts)
  end

  def gmail_users_watch(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_watch(conn, "me", optional_params, opts)
  end

  def gmail_users_stop(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_stop(conn, "me", optional_params, opts)
  end

  def gmail_users_drafts_list(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_drafts_list(conn, "me", optional_params, opts)
  end

  def gmail_users_drafts_get(user, draft_id, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_drafts_get(conn, "me", draft_id, optional_params, opts)
  end

  def gmail_users_drafts_delete(user, draft_id, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_drafts_delete(conn, "me", draft_id, optional_params, opts)
  end

  def gmail_users_messages_list(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_messages_list(conn, "me", optional_params, opts)
  end

  def gmail_users_messages_get(user, id, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_messages_get(conn, "me", id, optional_params, opts)
  end

  def gmail_users_messages_send(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_messages_send(conn, "me", optional_params, opts)
  end

  def gmail_users_messages_modify(user, id, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_messages_modify(conn, "me", id, optional_params, opts)
  end

  def gmail_users_history_list(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_history_list(conn, "me", optional_params, opts)
  end

  def gmail_users_labels_list(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_labels_list(conn, "me", optional_params, opts)
  end

  def gmail_users_labels_get(user, id, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_labels_get(conn, "me", id, optional_params, opts)
  end

  def gmail_users_labels_create(user, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_labels_create(conn, "me", optional_params, opts)
  end

  def gmail_users_labels_delete(user, id, optional_params \\ [], opts \\ []) do
    conn = Gmax.GoogleApi.new_connection(user)
    GmailApi.gmail_users_labels_delete(conn, "me", id, optional_params, opts)
  end
end
