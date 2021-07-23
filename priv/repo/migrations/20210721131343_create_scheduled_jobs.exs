defmodule Domain.Repo.Migrations.CreateScheduledJobs do
  use Ecto.Migration

  def change do
    create table(:scheduled_jobs) do
      add :description, :string
      add :started_at, :utc_datetime, null: false
      add :finished_at, :utc_datetime
      add :status, :string, null: false
    end
  end
end
