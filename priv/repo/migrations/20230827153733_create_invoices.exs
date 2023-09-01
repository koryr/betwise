defmodule Betwise.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :bet_amount, :decimal
      add :total_odds, :decimal
      add :status, :boolean, default: false
      add :complete, :boolean, default: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:invoices, [:user_id])
  end
end
