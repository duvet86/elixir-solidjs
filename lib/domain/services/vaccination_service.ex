defmodule Domain.Service.VaccinationService do
  import Ecto.Query, only: [where: 3, select: 3]

  alias Domain.Repo
  alias Domain.Model.Vaccination

  def create_vaccination(attrs \\ %{}) do
    %Vaccination{}
    |> Vaccination.create_changeset(attrs)
    |> Repo.insert()
  end

  def get_dates_by_location(location, start_date, end_date) do
    Vaccination
    |> where([v], v.location == ^location and v.date >= ^start_date and v.date <= ^end_date)
    |> select([v], v.date)
    |> Repo.all()
  end

  def insert_vaccinations(vaccinations) do
    Vaccination
    |> Repo.insert_all(vaccinations)
  end
end
