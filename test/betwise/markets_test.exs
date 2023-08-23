defmodule Betwise.MarketsTest do
  use Betwise.DataCase

  alias Betwise.Markets

  describe "markets" do
    alias Betwise.Markets.Market

    import Betwise.MarketsFixtures

    @invalid_attrs %{odds: nil}

    test "list_markets/0 returns all markets" do
      market = market_fixture()
      assert Markets.list_markets() == [market]
    end

    test "get_market!/1 returns the market with given id" do
      market = market_fixture()
      assert Markets.get_market!(market.id) == market
    end

    test "create_market/1 with valid data creates a market" do
      valid_attrs = %{odds: %{}}

      assert {:ok, %Market{} = market} = Markets.create_market(valid_attrs)
      assert market.odds == %{}
    end

    test "create_market/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Markets.create_market(@invalid_attrs)
    end

    test "update_market/2 with valid data updates the market" do
      market = market_fixture()
      update_attrs = %{odds: %{}}

      assert {:ok, %Market{} = market} = Markets.update_market(market, update_attrs)
      assert market.odds == %{}
    end

    test "update_market/2 with invalid data returns error changeset" do
      market = market_fixture()
      assert {:error, %Ecto.Changeset{}} = Markets.update_market(market, @invalid_attrs)
      assert market == Markets.get_market!(market.id)
    end

    test "delete_market/1 deletes the market" do
      market = market_fixture()
      assert {:ok, %Market{}} = Markets.delete_market(market)
      assert_raise Ecto.NoResultsError, fn -> Markets.get_market!(market.id) end
    end

    test "change_market/1 returns a market changeset" do
      market = market_fixture()
      assert %Ecto.Changeset{} = Markets.change_market(market)
    end
  end
end
