# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Domain.Repo.insert!(%Domain.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

users = [
  %{email: "jane.doe@example.com", password: "password"},
  %{email: "john.smith@example.org", password: "password"}
]

for user <- users do
  {:ok, _} = Domain.Service.UserService.create_user(user)
end
