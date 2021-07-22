defmodule Domain.Repo.Migrations.CreateVaccinations do
  use Ecto.Migration

  def change do
    create table("vaccinations") do
      add :location, :string
      add :date, :date
      add :vaccine, :string
      add :source_url, :string
      add :total_vaccinations, :integer
      add :people_vaccinated, :integer
      add :people_fully_vaccinated, :integer

      timestamps()
    end
  end
end
