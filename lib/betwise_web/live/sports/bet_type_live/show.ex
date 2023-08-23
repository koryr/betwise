defmodule BetwiseWeb.Sports.BetTypeLive.Show do
  use BetwiseWeb, :live_view

  alias Betwise.BetTypes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:bet_type, BetTypes.get_bet_type!(id))}
  end

  defp page_title(:show), do: "Show Bet type"
  defp page_title(:edit), do: "Edit Bet type"
end
