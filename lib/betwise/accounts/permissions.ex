defmodule Betwise.Accounts.Permissions do
  import Ecto.Changeset

  def all() do
    %{
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
      "emails" => ["create", "read", "update", "delete"]
    }
  end

  def validate_permissions(changeset, field) do
    validate_change(changeset, field, fn _field, permissions ->
      permissions
      |> Enum.reject(&has_permission?(all(), &1))
      |> case do
        [] -> []
        invalid_permissions -> [{field, {"invalid permissions", invalid_permissions}}]
      end
    end)
  end

  def has_permission?(permissions, {name, actions}) do
    exists?(name, permissions) && actions_valid?(name, actions, permissions)
  end

  defp exists?(name, permissions), do: Map.has_key?(permissions, name)

  defp actions_valid?(permission_name, given_action, permissions) when is_binary(given_action) do
    actions_valid?(permission_name, [given_action], permissions)
  end

  defp actions_valid?(permission_name, given_actions, permissions) when is_list(given_actions) do
    defined_actions = Map.get(permissions, permission_name)
    Enum.all?(given_actions, &(&1 in defined_actions))
  end

  def user_has_permission?(user, permission) do
    has_permission?(user.role.permissions, permission) ||
      has_permission?(user.custom_permissions, permission)
  end
end
