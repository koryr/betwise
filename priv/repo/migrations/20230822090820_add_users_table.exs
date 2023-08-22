defmodule Betwise.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users, primary_key: false) do
      add :first_name, :string
      add :last_name, :string
      add :msisdn, :bigint, null: false
      add :avatar, :string
      add :role_id, references(:roles, on_delete: :nothing)
      add :custom_permissions, :map
    end
    create unique_index(:users, [:msisdn])
  end
end
