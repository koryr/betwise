defmodule BetwiseWeb.Sports.SelectionLiveTest do
  use BetwiseWeb.ConnCase

  import Phoenix.LiveViewTest
  import Betwise.SelectionsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_selection(_) do
    selection = selection_fixture()
    %{selection: selection}
  end

  describe "Index" do
    setup [:create_selection]

    test "lists all selections", %{conn: conn, selection: selection} do
      {:ok, _index_live, html} = live(conn, ~p"/sports/selections")

      assert html =~ "Listing Selections"
      assert html =~ selection.name
    end

    test "saves new selection", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/selections")

      assert index_live |> element("a", "New Selection") |> render_click() =~
               "New Selection"

      assert_patch(index_live, ~p"/sports/selections/new")

      assert index_live
             |> form("#selection-form", selection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#selection-form", selection: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/selections")

      html = render(index_live)
      assert html =~ "Selection created successfully"
      assert html =~ "some name"
    end

    test "updates selection in listing", %{conn: conn, selection: selection} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/selections")

      assert index_live |> element("#selections-#{selection.id} a", "Edit") |> render_click() =~
               "Edit Selection"

      assert_patch(index_live, ~p"/sports/selections/#{selection}/edit")

      assert index_live
             |> form("#selection-form", selection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#selection-form", selection: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/selections")

      html = render(index_live)
      assert html =~ "Selection updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes selection in listing", %{conn: conn, selection: selection} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/selections")

      assert index_live |> element("#selections-#{selection.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#selections-#{selection.id}")
    end
  end

  describe "Show" do
    setup [:create_selection]

    test "displays selection", %{conn: conn, selection: selection} do
      {:ok, _show_live, html} = live(conn, ~p"/sports/selections/#{selection}")

      assert html =~ "Show Selection"
      assert html =~ selection.name
    end

    test "updates selection within modal", %{conn: conn, selection: selection} do
      {:ok, show_live, _html} = live(conn, ~p"/sports/selections/#{selection}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Selection"

      assert_patch(show_live, ~p"/sports/selections/#{selection}/show/edit")

      assert show_live
             |> form("#selection-form", selection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#selection-form", selection: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sports/selections/#{selection}")

      html = render(show_live)
      assert html =~ "Selection updated successfully"
      assert html =~ "some updated name"
    end
  end
end
