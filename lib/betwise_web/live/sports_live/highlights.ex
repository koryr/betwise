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

    selected_list =
      for bet <- mybets do
        to_string(bet.game_id) <> to_string(bet.selection_id)
      end

    total_odds =
      Enum.reduce(mybets, 0.0, fn value, acc -> string_to_numeric(value.odds) + acc end)

    changeset = Bets.change_bet(%Bet{})
    total_win = total_odds * 10.0

    # selected_list  = [to_string(bet.game_id) <> to_string(bet.selection_id) | socket.assigns.selected_list]
    IO.inspect("list#{inspect(selected_list)}")

    socket =
      socket
      |> assign(:info, "")
      |> assign(:total_odds, total_odds)
      |> assign(:total_win, total_win)
      |> assign(:bet_amount, 10.0)
      |> assign(:btn_disable, true)
      |> assign(:form, to_form(changeset))
      |> assign(:mybets, mybets)
      |> assign(:pick_list, selected_list)

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
    bet_amount = socket.assigns.bet_amount
    total_odds = Enum.reduce(data, 0, fn value, acc -> string_to_numeric(value.odds) + acc end)

    total_win = total_odds * bet_amount

    selected_list = [
      to_string(bet.game_id) <> to_string(bet.selection_id) | socket.assigns.pick_list
    ]

    IO.inspect("new list#{inspect(selected_list)}")

    socket =
      socket
      |> assign(:info, "")
      |> assign(:bet_amount, bet_amount)
      |> assign(:btn_disable, false)
      |> assign(:total_win, total_win)
      |> assign(:total_odds, total_odds)
      |> assign(:mybets, data)

    {:noreply, socket |> assign(:pick_list, selected_list)}
  end

  def handle_event(
        "placebet",
        %{"bet_amount" => amount, "total_odds" => total_odds} = _params,
        socket
      ) do
    user = socket.assigns.current_user
    result = PlaceBet.create_bet(user.id, amount, total_odds)

    socket =
      case result do
        true ->
          socket
          |> assign(:bet_amount, 10.0)
          |> assign(:total_win, nil)
          |> assign(:btn_disable, true)
          |> assign(:total_odds, 0.0)
          |> assign(:mybets, [])

        false ->
          socket
      end

    {
      :noreply,
      socket
      |> put_flash(:info, "Bet placed successfully")
      |> redirect(to: ~p"/sports/highlights")
    }
  end

  def handle_event("change-bet-amount", %{"bet_amount" => bet_amount}, socket) do
    total_odds = socket.assigns.total_odds
    total_win = total_odds * string_to_numeric(bet_amount)

    {:noreply,
     socket
     |> assign(:total_win, total_win)
     |> assign(:bet_amount, bet_amount)}
  end

  def handle_event("remove-bet", %{"game_id" => game_id}, socket) do
    IO.inspect("Removing a Bet")
    user = socket.assigns.current_user
    data = PlaceBet.remove_bet(user.id, game_id)

    total_odds = Enum.reduce(data, 0, fn value, acc -> string_to_numeric(value.odds) + acc end)

    total_win = total_odds * 10.0

    socket =
      socket
      |> assign(:bet_amount, 10.0)
      |> assign(:total_win, total_win)
      |> assign(:btn_disable, length(data) == 0)
      |> assign(:total_odds, total_odds)
      |> assign(:mybets, data)

    {:noreply, socket}
  end

  def string_to_numeric(val) when is_binary(val),
    do: _string_to_numeric(Regex.replace(~r{[^\d\.]}, val, ""))

  defp _string_to_numeric(val) when is_binary(val),
    do: _string_to_numeric(Integer.parse(val), val)

  defp _string_to_numeric(:error, _val), do: nil
  defp _string_to_numeric({num, ""}, _val), do: num
  defp _string_to_numeric({num, ".0"}, _val), do: num
  defp _string_to_numeric({_num, _str}, val), do: elem(Float.parse(val), 0)
end
