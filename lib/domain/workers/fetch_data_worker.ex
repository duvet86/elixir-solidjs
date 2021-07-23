defmodule Domain.Worker.FetchDataWorker do
  @moduledoc """
  Responsible of handling my job's schedule.
  
  """
  require Logger

  use GenServer

  import Domain.Service.ScheduledJobService
  import Domain.Service.VaccinationService

  alias Domain.HttpClient

  @country "Italy"

  # Interface

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  ## Callbacks

  @impl true
  def init(_) do
    schedule_initial_job()
    {:ok, nil}
  end

  @impl true
  def handle_info(:perform, state) do
    {:ok, scheduledJob} = start_job(@country)

    # https://github.com/owid/covid-19-data
    case HttpClient.request(
           Domain.HttpClient,
           "GET",
           "/owid/covid-19-data/master/public/data/vaccinations/country_data/#{@country}.csv",
           [],
           nil
         ) do
      {:ok, %{data: data}} ->
        try do
          # Convert data to stream for performance.
          {:ok, stream} =
            data
            |> StringIO.open()

          csv_vaccinations =
            stream
            |> IO.binstream(:line)
            |> Stream.map(&String.trim(&1, "\n"))
            |> Stream.drop(1)
            |> Stream.map(&String.split(&1, ~r/,(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)/))
            |> Stream.filter(fn row -> Enum.at(row, -1) != "" end)
            |> Enum.map(fn [
                             location,
                             date,
                             vaccine,
                             source_url,
                             total_vaccinations,
                             people_vaccinated,
                             people_fully_vaccinated
                           ] ->
              %{
                location: location,
                date: Date.from_iso8601!(date),
                vaccine: String.trim(vaccine, "\""),
                source_url: source_url,
                total_vaccinations: String.to_integer(total_vaccinations),
                people_vaccinated: String.to_integer(people_vaccinated),
                people_fully_vaccinated: String.to_integer(people_fully_vaccinated),
                inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
                updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
              }
            end)

          csv_dates = Enum.map(csv_vaccinations, fn v -> v[:date] end)
          csv_max_date = Enum.max(csv_dates, Date)
          csvmin_date = Enum.min(csv_dates, Date)

          db_vaccination_dates =
            get_dates_by_location(
              @country,
              csvmin_date,
              csv_max_date
            )

          new_vaccinations =
            Enum.filter(csv_vaccinations, &(!Enum.member?(db_vaccination_dates, &1[:date])))

          {inserted, nil} = insert_vaccinations(new_vaccinations)

          Logger.info(fn -> "Inserted: #{inserted}" end)

          set_success_job(scheduledJob)
          schedule_next_job()
          {:noreply, state}
        rescue
          e ->
            Logger.error(Exception.format(:error, e, __STACKTRACE__))
            set_error_job(scheduledJob)
            reraise e, __STACKTRACE__
        end

      {:error, _} ->
        set_error_job(scheduledJob)
        {:noreply, state}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, {names, refs}) do
    HttpClient.close_connection(Domain.HttpClient)
    {:noreply, {names, refs}}
  end

  defp schedule_initial_job() do
    # In 5 seconds
    Process.send_after(self(), :perform, 5_000)
  end

  defp schedule_next_job() do
    # In 60 seconds
    Process.send_after(self(), :perform, 60_000)
  end
end
