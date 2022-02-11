defmodule Gmax.Account do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false

  alias Gmax.Repo
  alias Gmax.Account.User

  def oauth2_registration("google" = provider, %{"id" => provider_id} = profile, client) do
    query = from(u in User, where: [oauth_provider: "google", oauth_provider_id: ^provider_id])

    attrs = %{
      "oauth_provider_id" => provider_id,
      "oauth_provider" => provider,
      "name" => profile["name"],
      "email" => profile["email"],
      "avatar_url" => profile["picture"],
      "hd" => profile["hd"],
      "access_token" => client.token.access_token,
      "access_token_expired_at" =>
        client.token.expires_at |> DateTime.from_unix!() |> DateTime.to_naive(),
      "refresh_token" => client.token.refresh_token
    }

    case query |> first |> Repo.one() do
      nil ->
        create_user(attrs)

      user ->
        # refresh token 只有在第一次连接 google 账号的时候有值，其他时候都为空
        # 还有一种情况，用户 revoke 了权限之后，又重新认证，这个时候需要用新的 refresh_token
        # 和 access_token 复写之前的。
        # 也就是说如果 attrs 如果有 refresh_token 和 access_token，就用新的覆盖之前的，
        # 否则维持原样。
        refresh_token =
          if client.token.refresh_token do
            client.token.refresh_token
          else
            user.refresh_token
          end

        access_token =
          if client.token.access_token do
            client.token.access_token
          else
            user.access_token
          end

        attrs = %{attrs | "refresh_token" => refresh_token, "access_token" => access_token}
        update_user(user, attrs)
    end
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by(clauses) do
    Repo.get_by(User, clauses)
  end

  def get_user_by!(clauses) do
    Repo.get_by!(User, clauses)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
