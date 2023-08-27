defmodule BetwiseWeb.SportsLive.Games.Show do
  use BetwiseWeb, :live_view

  alias Betwise.Games
  alias Betwise.Markets.Market

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    IO.inspect(Games.get_game!(id))
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:game, Games.get_game!(id))
     |> assign(:market, %Market{})
    }
  end

  defp page_title(:show), do: "Show Game"
  defp page_title(:edit), do: "Edit Game"
end