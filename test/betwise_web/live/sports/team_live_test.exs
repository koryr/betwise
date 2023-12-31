defmodule BetwiseWeb.Sports.TeamLiveTest do
  use BetwiseWeb.ConnCase

  import Phoenix.LiveViewTest
  import Betwise.TeamsFixtures

  @create_attrs %{team_name: "some team_name"}
  @update_attrs %{team_name: "some updated team_name"}
  @invalid_attrs %{team_name: nil}

  defp create_team(_) do
    team = team_fixture()
    %{team: team}
  end

  describe "Index" do
    setup [:create_team]

    test "lists all teams", %{conn: conn, team: team} do
      {:ok, _index_live, html} = live(conn, ~p"/sports/teams")

      assert html =~ "Listing Teams"
      assert html =~ team.team_name
    end

    test "saves new team", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/teams")

      assert index_live |> element("a", "New Team") |> render_click() =~
               "New Team"

      assert_patch(index_live, ~p"/sports/teams/new")

      assert index_live
             |> form("#team-form", team: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#team-form", team: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/teams")

      html = render(index_live)
      assert html =~ "Team created successfully"
      assert html =~ "some team_name"
    end

    test "updates team in listing", %{conn: conn, team: team} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/teams")

      assert index_live |> element("#teams-#{team.id} a", "Edit") |> render_click() =~
               "Edit Team"

      assert_patch(index_live, ~p"/sports/teams/#{team}/edit")

      assert index_live
             |> form("#team-form", team: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#team-form", team: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/sports/teams")

      html = render(index_live)
      assert html =~ "Team updated successfully"
      assert html =~ "some updated team_name"
    end

    test "deletes team in listing", %{conn: conn, team: team} do
      {:ok, index_live, _html} = live(conn, ~p"/sports/teams")

      assert index_live |> element("#teams-#{team.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#teams-#{team.id}")
    end
  end

  describe "Show" do
    setup [:create_team]

    test "displays team", %{conn: conn, team: team} do
      {:ok, _show_live, html} = live(conn, ~p"/sports/teams/#{team}")

      assert html =~ "Show Team"
      assert html =~ team.team_name
    end

    test "updates team within modal", %{conn: conn, team: team} do
      {:ok, show_live, _html} = live(conn, ~p"/sports/teams/#{team}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Team"

      assert_patch(show_live, ~p"/sports/teams/#{team}/show/edit")

      assert show_live
             |> form("#team-form", team: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#team-form", team: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/sports/teams/#{team}")

      html = render(show_live)
      assert html =~ "Team updated successfully"
      assert html =~ "some updated team_name"
    end
  end
end
