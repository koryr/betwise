defmodule BetwiseWeb.Sports.BetTypeLiveTest do
  use BetwiseWeb.ConnCase

  import Phoenix.LiveViewTest
  import Betwise.BetTypesFixtures

  @create_attrs %{bet_type_name: "some bet_type_name"}
  @update_attrs %{bet_type_name: "some updated bet_type_name"}
  @invalid_attrs %{bet_type_name: nil}

  defp create_bet_type(_) do
    bet_type = bet_type_fixture()
    %{bet_type: bet_type}
  end

  describe "Index" do
    setup [:create_bet_type]

    test "lists all bet_types", %{conn: conn, bet_type: bet_type} do
      {:ok, _index_live, html} = live(conn, ~p"/sports/bet_types")

      assert html =~ "Listing Bet types"
      assert html =~ bet_type.bet_type_name
    end

    test "saves new bet_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/bet_types")

      assert index_live |> element("a", "New Bet type") |> render_click() =~
               "New Bet type"

      assert_patch(index_live, ~p"/sports/bet_types/new")

      assert index_live
             |> form("#bet_type-form", bet_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bet_type-form", bet_type: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/bet_types")

      html = render(index_live)
      assert html =~ "Bet type created successfully"
      assert html =~ "some bet_type_name"
    end

    test "updates bet_type in listing", %{conn: conn, bet_type: bet_type} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/bet_types")

      assert index_live |> element("#bet_types-#{bet_type.id} a", "Edit") |> render_click() =~
               "Edit Bet type"

      assert_patch(index_live, ~p"/sports/bet_types/#{bet_type}/edit")

      assert index_live
             |> form("#bet_type-form", bet_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#bet_type-form", bet_type: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/bet_types")

      html = render(index_live)
      assert html =~ "Bet type updated successfully"
      assert html =~ "some updated bet_type_name"
    end

    test "deletes bet_type in listing", %{conn: conn, bet_type: bet_type} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/bet_types")

      assert index_live |> element("#bet_types-#{bet_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#bet_types-#{bet_type.id}")
    end
  end

  describe "Show" do
    setup [:create_bet_type]

    test "displays bet_type", %{conn: conn, bet_type: bet_type} do
      {:ok, _show_live, html} = live(conn, ~p"/sports/bet_types/#{bet_type}")

      assert html =~ "Show Bet type"
      assert html =~ bet_type.bet_type_name
    end

    test "updates bet_type within modal", %{conn: conn, bet_type: bet_type} do
      {:ok, show_live, _html} = live(conn, ~p"/sports/bet_types/#{bet_type}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Bet type"

      assert_patch(show_live, ~p"/sports/bet_types/#{bet_type}/show/edit")

      assert show_live
             |> form("#bet_type-form", bet_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#bet_type-form", bet_type: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sports/bet_types/#{bet_type}")

      html = render(show_live)
      assert html =~ "Bet type updated successfully"
      assert html =~ "some updated bet_type_name"
    end
  end
end
