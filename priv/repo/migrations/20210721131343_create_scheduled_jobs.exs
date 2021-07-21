defmodule Domain.Repo.Migrations.CreateScheduledJobs do
  use Ecto.Migration

  def change do
    create table(:scheduled_jobs) do
      add :description, :string
      add :started_at, :utc_datetime
      add :finished_at, :utc_datetime
      add :status, :string
    end
  end
end
