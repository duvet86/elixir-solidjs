defmodule Domain.Repo.Migrations.CreateVaccinations do
  use Ecto.Migration

  def change do
    create table(:vaccinations) do
      add :location, :string, null: false
      add :date, :date, null: false
      add :vaccine, :string, null: false
      add :source_url, :string, null: false
      add :total_vaccinations, :integer, default: 0
      add :people_vaccinated, :integer, default: 0
      add :people_fully_vaccinated, :integer, default: 0

      timestamps()
    end

    create unique_index(:vaccinations, [:location, :date])
  end
end
