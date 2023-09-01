defmodule BetwiseWeb.SportsLive.PlacedBets do
  alias Betwise.Bets
  use BetwiseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :bets, Bets.list_bets())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bets")
    |> assign(:bets, nil)
  end
end
