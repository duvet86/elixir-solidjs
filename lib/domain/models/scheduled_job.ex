defmodule Domain.Model.ScheduledJob do
  use Ecto.Schema

  import Ecto.Changeset

  schema "scheduled_jobs" do
    field :description, :string
    field :started_at, :utc_datetime
    field :finished_at, :utc_datetime
    field :status, Ecto.Enum, values: [:running, :success, :error]
  end

  def start_job_changeset(job, attrs) do
    job
    |> cast(attrs, [:description])
    |> change(%{started_at: DateTime.truncate(DateTime.utc_now(), :second), status: :running})
  end

  def finish_job_success_changeset(job) do
    job
    |> cast(%{}, [:description, :started_at, :status])
    |> change(%{finished_at: DateTime.truncate(DateTime.utc_now(), :second), status: :success})
  end

  def finish_job_error_changeset(job) do
    job
    |> change(%{finished_at: DateTime.truncate(DateTime.utc_now(), :second), status: :error})
  end
end
