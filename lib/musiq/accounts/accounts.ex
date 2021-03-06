require IEx
defmodule Musiq.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Musiq.Repo

  alias Musiq.Accounts.User

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

  def get_user(id) do
      user = Repo.get(User, id)
      |> Repo.preload([:created_groups, :following_groups])
  end

  def get_user_created_groups(id) do
      user = get_user(id)
      user.created_groups
  end

  def get_other_groups(id) do
    user = get_user(id)
    all_groups = Musiq.Music.list_groups
    Enum.filter(all_groups, fn(x) -> !Enum.any?(user.following_groups, fn(y) -> y.id == x.id end) end)
  end

  def get_user_following_groups(id) do
      user = get_user(id)
      user.following_groups
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


  def get_or_create_user(profile) do
    user = Repo.get_by(User, spotify_id: profile.id)
    if user do
      user
      |> Repo.preload([:created_groups, :following_groups])
    else
      user_params = %{ spotify_id: profile.id,
                       username: profile.display_name,
                       email: profile.email}

      create_user(user_params)
    end
  end

  def associate_group(user_id, group_id) do
    changeset = Musiq.UserGroup.changeset(%Musiq.UserGroup{}, %{user_id: user_id, group_id: group_id})
    Repo.insert(changeset)
  end

  def delete_association(user_id, group_id) do
    query = from ug in Musiq.UserGroup,
            where: ug.user_id == ^user_id and ug.group_id == ^group_id
    Repo.delete_all(query)
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
