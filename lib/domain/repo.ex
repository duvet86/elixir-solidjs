defmodule Domain.Repo do
  use Ecto.Repo,
    otp_app: :domain_app,
    adapter: Ecto.Adapters.Postgres
end
