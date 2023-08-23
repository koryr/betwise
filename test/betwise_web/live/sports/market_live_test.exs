defmodule BetwiseWeb.Sports.MarketLiveTest do
  use BetwiseWeb.ConnCase

  import Phoenix.LiveViewTest
  import Betwise.MarketsFixtures

  @create_attrs %{odds: %{}}
  @update_attrs %{odds: %{}}
  @invalid_attrs %{odds: nil}

  defp create_market(_) do
    market = market_fixture()
    %{market: market}
  end

  describe "Index" do
    setup [:create_market]

    test "lists all markets", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/sports/markets")

      assert html =~ "Listing Markets"
    end

    test "saves new market", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/markets")

      assert index_live |> element("a", "New Market") |> render_click() =~
               "New Market"

      assert_patch(index_live, ~p"/sports/markets/new")

      assert index_live
             |> form("#market-form", market: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#market-form", market: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/markets")

      html = render(index_live)
      assert html =~ "Market created successfully"
    end

    test "updates market in listing", %{conn: conn, market: market} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/markets")

      assert index_live |> element("#markets-#{market.id} a", "Edit") |> render_click() =~
               "Edit Market"

      assert_patch(index_live, ~p"/sports/markets/#{market}/edit")

      assert index_live
             |> form("#market-form", market: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#market-form", market: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/markets")

      html = render(index_live)
      assert html =~ "Market updated successfully"
    end

    test "deletes market in listing", %{conn: conn, market: market} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/markets")

      assert index_live |> element("#markets-#{market.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#markets-#{market.id}")
    end
  end

  describe "Show" do
    setup [:create_market]

    test "displays market", %{conn: conn, market: market} do
      {:ok, _show_live, html} = live(conn, ~p"/sports/markets/#{market}")

      assert html =~ "Show Market"
    end

    test "updates market within modal", %{conn: conn, market: market} do
      {:ok, show_live, _html} = live(conn, ~p"/sports/markets/#{market}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Market"

      assert_patch(show_live, ~p"/sports/markets/#{market}/show/edit")

      assert show_live
             |> form("#market-form", market: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#market-form", market: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sports/markets/#{market}")

      html = render(show_live)
      assert html =~ "Market updated successfully"
    end
  end
end
