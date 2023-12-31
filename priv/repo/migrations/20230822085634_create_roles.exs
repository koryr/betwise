defmodule Betwise.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :role_display_name, :string
      add :role_name, :string
      add :description, :string
      add :permissions, :map

      timestamps()
    end

    create unique_index(:roles, [:role_name, :role_display_name])

  end
end
