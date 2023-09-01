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
      add :deleted_at, :utc_datetime
    end
    create unique_index(:users, [:msisdn])
    create unique_index(:users, [:role_id])
  end
end
