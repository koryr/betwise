defmodule Betwise.Repo.Migrations.CreateBetTypes do
  use Ecto.Migration

  def change do
    create table(:bet_types) do
      add :bet_type_name, :string

      timestamps()
    end
  end
end
