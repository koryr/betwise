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

  def get_invoices() do
    from(s in Invoice, where: [complete: ^false])
    |> Repo.all()
    |> Repo.preload([:user])
  end

  def update_invoice(invoice, attrs \\ %{}) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  def get_profits() do
    result =
      from(i in Invoice,
        where: [status: ^false , complete: ^true],
        select: %{total_amount: sum(i.bet_amount)}
      )
      |> Repo.one()

    result.total_amount
  end

  def get_revenue_lost() do
    result =
      from(i in Invoice,
        where: [status: ^true ,complete: true],
        select: %{revenue_lost: sum(i.bet_amount* i.total_odds)}
      )
      |> Repo.one()

    result.revenue_lost
  end
end
