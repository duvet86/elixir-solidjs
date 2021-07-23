defmodule Domain.Service.UserService do
  @moduledoc """
  The User service.
  """

  alias Domain.Repo
  alias Domain.Model.User

  def list_users, do: Repo.all(User)

  def get_user!(id), do: Repo.get!(User, id)

  def get_by(email) do
    Repo.get_by(User, email: email)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_password_reset(attrs) do
    with %User{} = user <- get_by(attrs) do
      user
      |> User.password_reset_changeset(DateTime.truncate(DateTime.utc_now(), :second))
      |> Repo.update()
    end
  end
end
