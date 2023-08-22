defmodule Betwise.Accounts.DefaultRoles do
  def all() do
    [
      %{
        role_display_name: "Super Admin",
        role_name: "superuser",
        permissions: %{
          "roles" => ["create", "read", "update", "delete"],
          "users" => ["create", "read", "update", "delete"]
        }
      },
      %{
        role_display_name: "Admin",
        role_name: "admin",
        permissions: %{
          "roles" => ["read"],
          "users" => ["create", "read", "update", "delete"]
        }
      },
      %{
        role_display_name: "User",
        role_name: "user",
        permissions: %{
          "users" => ["read"]
        }
      }

    ]
  end
end
