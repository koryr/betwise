defmodule Betwise.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :bet_amount, :decimal
    field :total_odds, :decimal
    field :status, :boolean, default: false
    field :complete, :boolean, default: false
    belongs_to(:user, Betwise.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:bet_amount, :total_odds, :status, :user_id, :complete])
    |> validate_required([:bet_amount, :status])
  end
end
