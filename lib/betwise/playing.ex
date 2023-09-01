defmodule Betwise.Playing do
  alias Betwise.Games
  use GenServer

  @tab :games

  def start_link(game) do
    name = String.to_atom("game" <> Integer.to_string(game.id))
    GenServer.start_link(__MODULE__, game, name: name)
  end

  def init(game) do
    Process.send_after(self(), {:playing, game}, 20_000)
    {:ok, %{}}
  end

  def handle_call(_msg, _from, state) do
    {:reply, :ok, state}
  end

  def handle_info({:playing, game}, state) do
    IO.puts("Game is Playing now ")
    time_diff = Time.diff(game.time_to, game.time_from, :minute)
    :ets.insert(@tab, {game.id, game})
    Task.async(fn ->
      delay_seconds = 60 * time_diff

      IO.puts(
        "Waiting for #{time_diff} minute #{delay_seconds} seconds before starting the priority queue."
      )

      :timer.sleep(1000 * delay_seconds)
      data = %{home: Enum.random(0..4), away: Enum.random(0..4), full_time: true}

      Games.update_result(game, data)
      :ets.delete(@tab, game.id)
    end)

    {:noreply, state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}

  end
end
