defmodule BetwiseWeb.Auth.RoleLiveTest do
  use BetwiseWeb.ConnCase

  import Phoenix.LiveViewTest
  import Betwise.AccountsFixtures

  @create_attrs %{description: "some description", permissions: %{}, role_name: "some role_name"}
  @update_attrs %{description: "some updated description", permissions: %{}, role_name: "some updated role_name"}
  @invalid_attrs %{description: nil, permissions: nil, role_name: nil}

  defp create_role(_) do
    role = role_fixture()
    %{role: role}
  end

  describe "Index" do
    setup [:create_role]

    test "lists all roles", %{conn: conn, role: role} do
      {:ok, _index_live, html} = live(conn, ~p"/auth/roles")

      assert html =~ "Listing Roles"
      assert html =~ role.description
    end

    test "saves new role", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/auth/roles")

      assert index_live |> element("a", "New Role") |> render_click() =~
               "New Role"

      assert_patch(index_live, ~p"/auth/roles/new")

      assert index_live
             |> form("#role-form", role: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#role-form", role: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/auth/roles")

      html = render(index_live)
      assert html =~ "Role created successfully"
      assert html =~ "some description"
    end

    test "updates role in listing", %{conn: conn, role: role} do
      {:ok, index_live, _html} = live(conn, ~p"/auth/roles")

      assert index_live |> element("#roles-#{role.id} a", "Edit") |> render_click() =~
               "Edit Role"

      assert_patch(index_live, ~p"/auth/roles/#{role}/edit")

      assert index_live
             |> form("#role-form", role: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#role-form", role: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/auth/roles")

      html = render(index_live)
      assert html =~ "Role updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes role in listing", %{conn: conn, role: role} do
      {:ok, index_live, _html} = live(conn, ~p"/auth/roles")

      assert index_live |> element("#roles-#{role.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#roles-#{role.id}")
    end
  end

  describe "Show" do
    setup [:create_role]

    test "displays role", %{conn: conn, role: role} do
      {:ok, _show_live, html} = live(conn, ~p"/auth/roles/#{role}")

      assert html =~ "Show Role"
      assert html =~ role.description
    end

    test "updates role within modal", %{conn: conn, role: role} do
      {:ok, show_live, _html} = live(conn, ~p"/auth/roles/#{role}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Role"

      assert_patch(show_live, ~p"/auth/roles/#{role}/show/edit")

      assert show_live
             |> form("#role-form", role: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#role-form", role: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/auth/roles/#{role}")

      html = render(show_live)
      assert html =~ "Role updated successfully"
      assert html =~ "some updated description"
    end
  end
end
