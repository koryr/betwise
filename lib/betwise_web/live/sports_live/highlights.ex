defmodule BetwiseWeb.SportsLive.Highlights do
  use BetwiseWeb, :live_view
  alias Betwise.Games

  def mount(_params, _session, socket) do
    games = Games.list_games()
    {:ok, stream(socket, :games, games)}
  end

end
