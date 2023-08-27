defmodule Betwise.PlaceBet do
  alias Betwise.Bets
  alias Betwise.Bets.Bet
  alias Betwise.Invoices
  alias Betwise.Invoices.Invoice
  use GenServer
  @tab :bets

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def bet(bet) do
    GenServer.call(__MODULE__, {:placebet, bet})
  end

  def get_bets(user_id) do
    GenServer.call(__MODULE__, {:getbets, user_id})
  end

  def create_bet(user_id, amount) do
    GenServer.cast(__MODULE__, {:createbet, {user_id, amount}})
  end

  def remove_bet(user_id, selection_id) do
    GenServer.call(__MODULE__, {:removebet, {user_id, selection_id}})
  end

  def init([]) do
    :ets.new(@tab, [:set, :public, :named_table])
    {:ok, %{}}
  end

  def handle_call({:placebet, bet}, _from, state) do
    case :ets.lookup(@tab, bet.user_id) do
      [{_key, values}] ->
        game =
          for value <- values,
              value.game_id == bet.game_id,
              do: value

        case game do
          [game_selected] ->
            updated_list = List.delete(values, game_selected)
            new_bet = [bet | updated_list]
            :ets.insert(@tab, {bet.user_id, new_bet})

          [] ->
            new_bet = [bet | values]
            :ets.insert(@tab, {bet.user_id, new_bet})
        end

      [] ->
        :ets.insert_new(@tab, {bet.user_id, [bet]})
    end

    [{_, data}] = :ets.lookup(@tab, bet.user_id)

    {:reply, data, state}
  end

  def handle_call({:getbets, user_id}, _from, state) do
    bets =
      case :ets.lookup(@tab, user_id) do
        [] ->
          []

        [{_, data}] ->
          data
      end

    {:reply, bets, state}
  end

  def handle_call({:removebet, {user_id, game_id}}, _from, state) do
    case :ets.lookup(@tab, user_id) do
      [{_key, values}] ->
        game =
          for value <- values,
              value.game_id == game_id,
              do: value

        case game do
          [game_selected] ->
            updated_list = List.delete(values, game_selected)

            :ets.insert(@tab, {user_id, updated_list})

          [] ->
            IO.inspect("nothing to remove")
        end

      [] ->
        IO.inspect("nothing to remove")
    end

    [{_, data}] = :ets.lookup(@tab, user_id)

    {:reply, data, state}
  end

  def handle_cast({:createbet, {user_id, amount}}, state) do
    bets =
      case :ets.lookup(@tab, user_id) do
        [] ->
          []

        [{_, data}] ->
          data
      end

    params = %{"user_id" => user_id, "bet_amount" => amount}

    case Invoices.create_invoice(params) do
      {:ok, invoice} ->
        Enum.map(bets, fn bet ->
          %{
            "game_id" => bet.game_id,
            "selection_id" => bet.selection_id,
            "invoice_id" => invoice.id
          }
          |> Bets.create_bet()
        end)

        :ets.delete(@tab, user_id)

      {:error, changeset} ->
        {:error, changeset}
    end

    IO.inspect("bets#{inspect(bets)}")
    IO.inspect("userd#{inspect(user_id)}")

    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
