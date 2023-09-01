defmodule BetwiseWeb.SportsLive.Games.Show do
  alias Betwise.Accounts.Permissions
  use BetwiseWeb, :live_view

  alias Betwise.Games
  alias Betwise.Markets.Market

  @impl true
  def mount(_params, _session, socket) do
    socket =
      if Permissions.user_has_permission?(
           socket.assigns.current_user,
           required_permission(socket.assigns.live_action)
         ) do
        socket
      else
        socket
        |> put_flash(:error, "Could not find the user")
        |> push_patch(to: socket.assigns.patch)
      end
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    IO.inspect(Games.get_game!(id))

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, Games.get_game!(id))
     |> assign(:market, %Market{})}
  end

  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"

  @impl true
  def handle_info({BetwiseWeb.SportsLive.Games.FormComponent, {:saved, game}}, socket) do
    {:noreply, socket |> assign(:games, game)}
  end

  @impl true
  def handle_info({BetwiseWeb.SportsLive.Games.AddOddsComponent, {:saved, game}}, socket) do
    {:noreply, socket |> assign(:games, game)}
  end

  defp required_permission(action) do
    list = [
      index: {"games", "read"},
      new: {"games", "create"},
      show: {"games", "read"},
      delete: {"games", "delete"}
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
