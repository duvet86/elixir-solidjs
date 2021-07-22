defmodule Domain.Model.Vaccination do
  use Ecto.Schema

  import Ecto.Changeset

  schema "vaccinations" do
    field :location, :string
    field :date, :date
    field :vaccine, :string
    field :source_url, :string
    field :total_vaccinations, :integer
    field :people_vaccinated, :integer
    field :people_fully_vaccinated, :integer

    timestamps()
  end

  def create_changeset(vaccination, attrs) do
    vaccination
    |> cast(attrs, [
      :location,
      :date,
      :vaccine,
      :source_url,
      :total_vaccinations,
      :people_vaccinated,
      :people_fully_vaccinated
    ])
  end
end
