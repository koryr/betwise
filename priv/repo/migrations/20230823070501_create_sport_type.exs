defmodule Betwise.Repo.Migrations.CreateSportType do
  use Ecto.Migration

  def change do
    create table(:sport_types) do
      add :sport_name, :string
      add :description, :string

      timestamps()
    end
  end
end
