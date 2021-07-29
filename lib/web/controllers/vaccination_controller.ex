defmodule Web.VaccinationController do
  use Web, :controller

  import Domain.Service.VaccinationService

  def index(conn, params) do
    case params do
      %{"location" => location} ->
        json(
          conn,
          Enum.map(get_by_location(location), fn v ->
            %{
              location: v.location,
              date: v.date,
              vaccine: v.vaccine,
              source_url: v.source_url,
              total_vaccinations: v.total_vaccinations,
              people_vaccinated: v.people_vaccinated,
              people_fully_vaccinated: v.people_fully_vaccinated,
              inserted_at: v.inserted_at
            }
          end)
        )

      _ ->
        json(
          conn,
          Enum.map(get_all(), fn v ->
            %{
              location: v.location,
              date: v.date,
              vaccine: v.vaccine,
              source_url: v.source_url,
              total_vaccinations: v.total_vaccinations,
              people_vaccinated: v.people_vaccinated,
              people_fully_vaccinated: v.people_fully_vaccinated,
              inserted_at: v.inserted_at
            }
          end)
        )
    end
  end
end
