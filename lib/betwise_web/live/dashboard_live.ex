defmodule BetwiseWeb.DashboardLive do
  alias Betwise.Accounts.Permissions
  alias Betwise.Invoices
  use BetwiseWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      if Permissions.user_has_permission?(
           socket.assigns.current_user,
           required_permission(socket.assigns.live_action)
         ) do
        socket
        |> assign(:total_amount, Invoices.get_profits())
        |> assign(:revenue_lost, Invoices.get_revenue_lost())
      else
        socket
        |> put_flash(:info, "Welcome back")
        |> redirect(to: ~p"/sports/highlights")
      end

    # socket = socket
    # |> assign(:total_amount, Invoices.get_profits)
    # |> assign(:revenue_lost, Invoices.get_revenue_lost)

    {:ok, socket}
  end

  defp required_permission(action) do
    list = [
      index: {"dashboard", "read"},
      new: {"dashboard", "create"},
      show: {"dashboard", "read"},
      delete: {"dashboard", "delete"}
    ]

    result = Enum.find(list, fn {key, _value} -> key == action end)

    case result do
      {_key, value} ->
        value

      nil ->
        IO.puts("Permission not found")
    end
  end
end
