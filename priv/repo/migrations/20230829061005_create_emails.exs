defmodule Betwise.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add :email_from, :string
      add :recipient, :string
      add :subject, :string
      add :content, :string
      add :send, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:emails, [:user_id])
  end
end
