defmodule BetwiseWeb.Menus do
  use BetwiseWeb, :html

  def main_menu_items(current_user),
    do:
      build_menu(
        [
          :dashboard,
          :sport_types,
          :teams,
          :bet_types,
          :games,
          :selections,
          :users,
          :roles
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
    Enum.map(links, fn link -> get_link(link, current_user) end)
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
      label: "Profile",
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
end
