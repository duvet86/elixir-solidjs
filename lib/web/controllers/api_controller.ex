defmodule Web.ApiController do
  use Web, :controller

  import Web.Plugs.Auth, only: [generate_token: 1]
  import Domain.Auth, only: [get_by: 1]

  def test(conn, _params) do
    json(conn, %{test: "Luca"})
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case get_by(email) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(Web.ErrorView)
        |> render(:"401")
        # Stop any downstream transformations.
        |> halt()

      user ->
        Pbkdf2.check_pass(email, password)
        token = generate_token(user.id)
        json(conn, %{token: token})
    end
  end
end
