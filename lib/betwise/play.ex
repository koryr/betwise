defmodule Betwise.Play do
  alias Betwise.PlayingSup
  alias Betwise.Games
  use GenServer

  @tab :games

  @initial_state %{pq: nil, datecreated: nil}

  def start_link([]) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    :ets.new(@tab, [:set, :public, :named_table])
    IO.inspect("Play server started.........")

    Process.send_after(self(), :play_game, 30_000)
    {:ok, %{@initial_state | datecreated: Date.utc_today()}}
  end

  # Handle messages sent to the GenServer
  def handle_info(:play_game, %{datecreated: datecreated} = state) do
    pq = PriorityQueue.new()
    IO.puts("Priority queue task at #{inspect(System.system_time(:second))}")

    new_state =
      case Games.get_games(datecreated) do
        games ->
          pqw =
            for game <- games, into: pq do
              PriorityQueue.put(pq, game, Time.diff(game.time_from, Time.utc_now(), :minute))
            end

          latest_game =
            case games do
              [_ | _] ->
                result = Enum.max_by(games, & &1.inserted_at)
                result.inserted_at

              [] ->
                Date.utc_today()
            end
            Process.send_after(self(), :play_now, 10_000)
          %{state | pq: pqw, datecreated: latest_game}
      end


    # Schedule the next execution
    # 10 seconds
    Process.send_after(self(), :play_game, 10_000)

    {:noreply, new_state}
  end

  def handle_info(:play_now, %{pq: pq} = state) do
    # Pop items with the highest priority
    item =
      pq
      |> PriorityQueue.empty?()
      |> case do
        true ->
          IO.inspect("empty queue")

        false ->
          pq
          |> PriorityQueue.min!()
      end

    case item do
      {key, _rest} ->
        {game, _rest, _} = key.heap
        play_game(game)
        pq |> PriorityQueue.delete_min()

      _ ->
        []
    end

    {:noreply, state}
  end

  # Start playing game
  defp play_game(game) do
    case PlayingSup.start_playing(game) do
      {:ok, pid} ->
        IO.puts("#{inspect(pid)}Game started")

        {:ok, pid}

      {:error, error} ->
        IO.inspect("Game start error:#{inspect(error)}")
        {:error, error}
    end
  end
end
