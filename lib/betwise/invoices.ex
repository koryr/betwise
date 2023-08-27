defmodule Betwise.Invoices do

  import Ecto.Query, warn: false
  alias Betwise.Invoices.Invoice
  alias Betwise.Repo

  def list_invoices() do
    Repo.all(Invoice)
    |> Repo.preload([:user])
  end

  def create_invoice(attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Repo.insert()
  end

  def change_invoice(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.changeset(invoice, attrs)
  end

end
