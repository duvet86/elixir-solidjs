defmodule Domain.FetchDataWorker do
  @moduledoc """
  Responsible of handling my job's schedule.
  
  """
  use GenServer

  alias Domain.HttpClient
  alias Domain.Repo
  alias Domain.Model.ScheduledJob

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
    {:ok, scheduledJob} =
      %ScheduledJob{}
      |> ScheduledJob.start_job_changeset(%{})
      |> Repo.insert()

    # https://github.com/owid/covid-19-data
    case HttpClient.request(
           Domain.HttpClient,
           "GET",
           "/owid/covid-19-data/master/public/data/vaccinations/country_data/Afghanistan.csv",
           [],
           nil
         ) do
      {:ok, %{data: _data}} ->
        scheduledJob
        |> ScheduledJob.finish_job_success_changeset()
        |> Repo.update()

        # Io.puts(data)

        schedule_next_job()
        {:noreply, state}

      {:error, _} ->
        scheduledJob
        |> ScheduledJob.finish_job_error_changeset()
        |> Repo.update()

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
