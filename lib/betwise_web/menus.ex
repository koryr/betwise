defmodule BetwiseWeb.Menus do
  alias Betwise.Accounts.Permissions
  use BetwiseWeb, :html

  def main_menu_items(current_user),
    do:
      build_menu(
        [
          if Permissions.user_has_permission?(current_user, {"dashboard", ["read"]}) do
            :dashboard
          end,
          if Permissions.user_has_permission?(current_user, {"highlights", ["read"]}) do
            :highlights
          end,
          if Permissions.user_has_permission?(current_user, {"bets", ["read"]}) do
            :bets
          end,
          if Permissions.user_has_permission?(current_user, {"games", ["read"]}) do
            :games
          end,
          if Permissions.user_has_permission?(current_user, {"teams", ["read"]}) do
            :teams
          end,
          if Permissions.user_has_permission?(current_user, {"sport_types", ["read"]}) do
            :sport_types
          end,
          if Permissions.user_has_permission?(current_user, {"selections", ["read"]}) do
            :selections
          end,
          if Permissions.user_has_permission?(current_user, {"bet_types", ["read"]}) do
            :bet_types
          end,
          if Permissions.user_has_permission?(current_user, {"users", ["read"]}) do
            :users
          end,
          if Permissions.user_has_permission?(current_user, {"roles", ["read"]}) do
            :roles
          end,
          if Permissions.user_has_permission?(current_user, {"emails", ["read"]}) do
            :emails
          end
          # ,
          # %{
          #   name: :company,
          #   label: "Company",
          #   icon: :building_office,
          #   menu_items: []
          # }
        ],
        current_user
      )

  def user_menu_items(current_user),
    do:
      build_menu(
        [
          :profile,
          :settings,
          :logout
        ],
        current_user
      )

  def build_menu(links, current_user) do
    Enum.map(links, fn link ->
      if !is_nil(link) do
        get_link(link, current_user)
      end
    end)
  end

  def get_link(:dashboard, _current_user) do
    %{
      name: :dashboard,
      label: "Dashboard",
      path: ~p"/",
      icon: "hero-home"
    }
  end

  def get_link(:roles, _current_user) do
    %{
      name: :roles,
      label: "Roles",
      path: ~p"/auth/roles",
      icon: "hero-tag"
    }
  end

  def get_link(:sport_types, _current_user) do
    %{
      name: :sport_types,
      label: "Sport Type",
      path: ~p"/sports/sport-types",
      icon: "hero-cube-transparent"
    }
  end

  def get_link(:users, _current_user) do
    %{
      name: :users,
      label: "Users",
      path: ~p"/users",
      icon: "hero-users"
    }
  end

  def get_link(:profile, current_user) do
    %{
      name: :profile,
      label: "Account",
      path: ~p"/users/p/#{current_user.email}",
      icon: "hero-user"
    }
  end

  def get_link(:settings, _current_user) do
    %{
      name: :settings,
      label: "Settings",
      path: ~p"/auth/users/settings",
      icon: "hero-cog-8-tooth"
    }
  end

  def get_link(:logout, _current_user) do
    %{
      name: :logout,
      label: "Logout",
      path: ~p"/auth/users/log_out",
      method: "delete",
      icon: "hero-arrow-left-on-rectangle"
    }
  end

  def get_link(:teams, _current_user) do
    %{
      name: :teams,
      label: "Teams",
      path: ~p"/sports/teams",
      icon: "hero-cube-transparent"
    }
  end

  def get_link(:bet_types, _current_user) do
    %{
      name: :bet_types,
      label: "Bet Types",
      path: ~p"/sports/bet_types",
      icon: "hero-cube-transparent"
    }
  end

  def get_link(:games, _current_user) do
    %{
      name: :games,
      label: "Sport Games",
      path: ~p"/sports/games",
      icon: "hero-cube-transparent"
    }
  end

  def get_link(:selections, _current_user) do
    %{
      name: :selections,
      label: "Bet Selection",
      path: ~p"/sports/selections",
      icon: "hero-cube-transparent"
    }
  end

  def get_link(:highlights, _current_user) do
    %{
      name: :highlights,
      label: "Sports Highlights",
      path: ~p"/sports/highlights",
      icon: "hero-cube-transparent"
    }
  end

  def get_link(:bets, _current_user) do
    %{
      name: :highlights,
      label: "Bets",
      path: ~p"/sports/bets",
      icon: "hero-cube-transparent"
    }
  end

  def get_link(:emails, _current_user) do
    %{
      name: :emails,
      label: "Emails",
      path: ~p"/emails",
      icon: "hero-inbox"
    }
  end
end
