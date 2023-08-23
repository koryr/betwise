defmodule BetwiseWeb.Plugs.CheckPermissions do
  import Plug.Conn
  import Phoenix.Controller, only: [action_name: 1]

  alias Betwise.Repo
  alias Betwise.Accounts.Permissions
  def init(opts), do: opts

  def call(conn, opts) do
    user = get_user(conn)
    required_permission = get_required_permission(conn, opts)

    if Permissions.user_has_permission?(user, required_permission) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> halt()
    end
  end

  defp get_user(conn) do
    user = conn.assigns.current_user
    Repo.preload(user, :role)
  end

  defp get_required_permission(conn, opts) do
    action = action_name(conn)

    opts
    |> Keyword.fetch!(:actions)
    |> Keyword.fetch!(action)
  end
end
