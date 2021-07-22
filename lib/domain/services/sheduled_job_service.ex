defmodule Domain.Service.ScheduledJobService do
  @moduledoc """
  The ScheduledJobService service.
  """

  alias Domain.Repo
  alias Domain.Model.ScheduledJob

  def list_jobs, do: Repo.all(ScheduledJob)

  def list_running_jobs, do: Repo.get_by(ScheduledJob, status: :running)

  def list_finished_jobs, do: Repo.get_by(ScheduledJob, status: :success)

  def start_job do
    %ScheduledJob{}
    |> ScheduledJob.start_job_changeset(%{})
    |> Repo.insert()
  end

  def set_success_job(scheduledJob) do
    scheduledJob
    |> ScheduledJob.finish_job_success_changeset()
    |> Repo.update()
  end

  def set_error_job(scheduledJob) do
    scheduledJob
    |> ScheduledJob.finish_job_error_changeset()
    |> Repo.update()
  end
end
