defmodule BetwiseWeb.SportsLive.Highlights do
  use BetwiseWeb, :live_view
  alias Betwise.Games
  alias Betwise.Model.{MyBet}
  alias Betwise.PlaceBet
  alias Betwise.Bets
  alias Betwise.Bets.Bet

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    games = Games.list_games()
    mybets = PlaceBet.get_bets(user.id)
    total_odds = Enum.reduce(mybets, 0, fn value, acc -> String.to_integer(value.odds) + acc end)
    changeset = Bets.change_bet(%Bet{})
    total_win = total_odds * 10.0

    socket =
      socket
      |> assign(:total_odds, total_odds)
      |> assign(:total_win, total_win)
      |> assign(:bet_amount, 10.0)
      |> assign(:form, to_form(changeset))
      |> assign(:mybets, mybets)

    {:ok, stream(socket, :games, games)}
  end

  def handle_event(
        "select-odds",
        params,
        socket
      ) do
    user = socket.assigns.current_user

    new_params =
      params
      |> Map.put_new("user_id", user.id)
      |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)

    bet =
      %MyBet{}
      |> Map.merge(new_params)

    data = PlaceBet.bet(bet)
    total_odds = Enum.reduce(data, 0, fn value, acc -> String.to_integer(value.odds) + acc end)
    total_win = total_odds * 10.0

    socket =
      socket
      |> assign(:bet_amount, 10.0)
      |> assign(:total_win, total_win)
      |> assign(:total_odds, total_odds)
      |> assign(:mybets, data)

    {:noreply, socket}
  end

  def handle_event("placebet", %{"bet_amount" => amount} = _params, socket) do
    IO.inspect("plaebet#{amount}")
    user = socket.assigns.current_user
    PlaceBet.create_bet(user.id, amount)
    {:noreply, socket}
  end

  def handle_event("change-bet-amount", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end

  def handle_event("remove-bet", %{"game_id" => game_id} = params, socket) do
    IO.inspect(params)
    user = socket.assigns.current_user
    data = PlaceBet.remove_bet(user.id, game_id)
    total_odds = Enum.reduce(data, 0, fn value, acc -> String.to_integer(value.odds) + acc end)
    total_win = total_odds * 10.0

    socket =
      socket
      |> assign(:bet_amount, 10.0)
      |> assign(:total_win, total_win)
      |> assign(:total_odds, total_odds)
      |> assign(:mybets, data)

    {:noreply, socket}
  end
end
