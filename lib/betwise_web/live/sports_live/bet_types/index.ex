defmodule BetwiseWeb.SportsLive.BetTypes.Index do
  use BetwiseWeb, :live_view

  alias Betwise.BetTypes
  alias Betwise.BetTypes.BetType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :bet_types, BetTypes.list_bet_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Bet type")
    |> assign(:bet_type, BetTypes.get_bet_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Bet type")
    |> assign(:bet_type, %BetType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Bet types")
    |> assign(:bet_type, nil)
  end

  @impl true
  def handle_info({BetwiseWeb.Sports.BetTypeLive.FormComponent, {:saved, bet_type}}, socket) do
    {:noreply, stream_insert(socket, :bet_types, bet_type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    bet_type = BetTypes.get_bet_type!(id)
    {:ok, _} = BetTypes.delete_bet_type(bet_type)

    {:noreply, stream_delete(socket, :bet_types, bet_type)}
  end
end
