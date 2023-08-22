defmodule BetwiseWeb.Menus do
  use BetwiseWeb, :html

  def main_menu_items(current_user),
    do:
      build_menu(
        [
          :dashboard,
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
      icon: :clipboard_list
    }
  end

  def get_link(:roles, _current_user) do
    %{
      name: :roles,
      label: "Roles",
      path: ~p"/auth/roles",
      icon: :clipboard_list
    }
  end

  def get_link(:users, _current_user) do
    %{
      name: :users,
      label: "Users",
      path: ~p"/users",
      icon: :clipboard_list
    }
  end

  def get_link(:profile, current_user) do
    %{
      name: :profile,
      label: "Profile",
      path: ~p"/#{current_user.email}",
      icon: :user
    }
  end

  def get_link(:settings, _current_user) do
    %{
      name: :settings,
      label: "Settings",
      path: ~p"/auth/users/settings",
      icon: :clipboard_list
    }
  end

  def get_link(:logout, _current_user) do
    %{
      name: :logout,
      label: "Logout",
      path: ~p"/auth/users/log_out",
      method: "delete",
      icon: :clipboard_list
    }
  end
end
