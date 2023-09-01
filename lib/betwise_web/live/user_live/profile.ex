defmodule BetwiseWeb.UserLive.Profile do
  alias Betwise.Bets
  use BetwiseWeb, :live_view

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    {:ok, stream(socket, :bets, Bets.list_bets(user.id))}
  end

  def handle_event("cancel", %{"id" => id} = params, socket) do
    IO.inspect(params)
    bet = Bets.cancel_bet(id,%{canceled: true})
    IO.inspect(bet)
    {:noreply, socket}
  end
end
