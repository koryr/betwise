defmodule Betwise.Accounts.DefaultRoles do
  def all() do
    [
      %{
        role_display_name: "Super Admin",
        role_name: "superuser",
        permissions: %{
          "roles" => ["create", "read", "update", "delete"],
          "users" => ["create", "read", "update", "delete"],
          "sport_types" => ["create", "read", "update", "delete"],
          "bet_types" => ["create", "read", "update", "delete"],
          "bets" => ["create", "read", "update", "delete"],
          "highlights" => ["create", "read", "update", "delete"],
          "games" => ["create", "read", "update", "delete"],
          "teams" => ["create", "read", "update", "delete"],
          "selections" => ["create", "read", "update", "delete"],
          "invoices" => ["create", "read", "update", "delete"],
          "dashboard" => [ "read"],
          "markets" => ["create", "read", "update", "delete"],
          "emails" => ["create", "read", "update", "delete"],
        }
      },
      %{
        role_display_name: "Admin",
        role_name: "admin",
        permissions: %{
          "users" => ["create", "read", "update", "delete"],
          "dashboard" => [ "read"],
          "bets" => ["create", "read", "update", "delete"],
          "games" => ["create", "read", "update", "delete"],
          "highlights" => ["create", "read", "update", "delete"],
          "invoices" => ["create", "read", "update", "delete"],
          "emails" => ["create", "read", "update", "delete"],
        }
      },
      %{
        role_display_name: "User",
        role_name: "user",
        permissions: %{
          "highlights" => ["read"],
        }
      }
    ]
  end
end
