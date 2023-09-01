defmodule Betwise.Repo.Migrations.CreateBets do
  use Ecto.Migration

  def change do
    create table(:bets) do
      add :odds, :decimal
      add :status, :boolean
      add :canceled, :boolean, default: false
      add :game_id, references(:games, on_delete: :nothing)
      add :bet_type_id, references(:bet_types, on_delete: :nothing)
      add :selection_id, references(:selections, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :invoice_id, references(:invoices, on_delete: :nothing)

      timestamps()
    end

    create index(:bets, [:game_id])
    create index(:bets, [:bet_type_id])
    create index(:bets, [:selection_id])
    create index(:bets, [:user_id])
    create index(:bets, [:invoice_id])
    create unique_index(:bets, [:game_id, :user_id])
  end
end
