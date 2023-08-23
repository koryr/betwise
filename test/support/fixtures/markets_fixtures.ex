defmodule Betwise.MarketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Betwise.Markets` context.
  """

  @doc """
  Generate a market.
  """
  def market_fixture(attrs \\ %{}) do
    {:ok, market} =
      attrs
      |> Enum.into(%{
        odds: %{}
      })
      |> Betwise.Markets.create_market()

    market
  end
end
