defmodule Domain.Service.VaccinationService do
  alias Domain.Repo
  alias Domain.Model.Vaccination

  def create_vaccination(attrs \\ %{}) do
    %Vaccination{}
    |> Vaccination.create_changeset(attrs)
    |> Repo.insert()
  end
end
