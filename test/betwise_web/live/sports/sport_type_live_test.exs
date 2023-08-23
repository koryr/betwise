defmodule BetwiseWeb.Sports.SportTypeLiveTest do
  use BetwiseWeb.ConnCase

  import Phoenix.LiveViewTest
  import Betwise.SportsFixtures

  @create_attrs %{sport_name: "some sport_name"}
  @update_attrs %{sport_name: "some updated sport_name"}
  @invalid_attrs %{sport_name: nil}

  defp create_sport_type(_) do
    sport_type = sport_type_fixture()
    %{sport_type: sport_type}
  end

  describe "Index" do
    setup [:create_sport_type]

    test "lists all sport_type", %{conn: conn, sport_type: sport_type} do
      {:ok, _index_live, html} = live(conn, ~p"/sports/sport_type")

      assert html =~ "Listing Sport type"
      assert html =~ sport_type.sport_name
    end

    test "saves new sport_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/sport_type")

      assert index_live |> element("a", "New Sport type") |> render_click() =~
               "New Sport type"

      assert_patch(index_live, ~p"/sports/sport_type/new")

      assert index_live
             |> form("#sport_type-form", sport_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sport_type-form", sport_type: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/sport_type")

      html = render(index_live)
      assert html =~ "Sport type created successfully"
      assert html =~ "some sport_name"
    end

    test "updates sport_type in listing", %{conn: conn, sport_type: sport_type} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/sport_type")

      assert index_live |> element("#sport_type-#{sport_type.id} a", "Edit") |> render_click() =~
               "Edit Sport type"

      assert_patch(index_live, ~p"/sports/sport_type/#{sport_type}/edit")

      assert index_live
             |> form("#sport_type-form", sport_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#sport_type-form", sport_type: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/sport_type")

      html = render(index_live)
      assert html =~ "Sport type updated successfully"
      assert html =~ "some updated sport_name"
    end

    test "deletes sport_type in listing", %{conn: conn, sport_type: sport_type} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/sport_type")

      assert index_live |> element("#sport_type-#{sport_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#sport_type-#{sport_type.id}")
    end
  end

  describe "Show" do
    setup [:create_sport_type]

    test "displays sport_type", %{conn: conn, sport_type: sport_type} do
      {:ok, _show_live, html} = live(conn, ~p"/sports/sport_type/#{sport_type}")

      assert html =~ "Show Sport type"
      assert html =~ sport_type.sport_name
    end

    test "updates sport_type within modal", %{conn: conn, sport_type: sport_type} do
      {:ok, show_live, _html} = live(conn, ~p"/sports/sport_type/#{sport_type}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Sport type"

      assert_patch(show_live, ~p"/sports/sport_type/#{sport_type}/show/edit")

      assert show_live
             |> form("#sport_type-form", sport_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#sport_type-form", sport_type: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sports/sport_type/#{sport_type}")

      html = render(show_live)
      assert html =~ "Sport type updated successfully"
      assert html =~ "some updated sport_name"
    end
  end
end
