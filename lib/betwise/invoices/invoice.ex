defmodule Betwise.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :bet_amount, :decimal
    field :status, :boolean, default: false
    belongs_to(:user, Betwise.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:bet_amount, :status,:user_id])
    |> validate_required([:bet_amount, :status])
  end
end
