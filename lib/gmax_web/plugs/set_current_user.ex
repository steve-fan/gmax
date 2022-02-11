defmodule GmaxWeb.Plug.SetCurrentUser do
  import Plug.Conn

  @valid_email_pattern ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    email = Map.get(conn.params, "email")

    if is_nil(email) || !Regex.match?(@valid_email_pattern, email) do
      assign(conn, :current_user, nil)
    else
      user_id = get_session(conn, "_gmax_user:#{email}")
      user = user_id && repo.get(Gmax.Account.User, user_id)

      case user do
        %Gmax.Account.User{} = current_user ->
          assign(conn, :current_user, current_user)

        _ ->
          assign(conn, :current_user, nil)
      end
    end
  end
end
