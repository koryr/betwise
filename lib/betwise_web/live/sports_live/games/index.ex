defmodule BetwiseWeb.SportsLive.Games.Index do
  alias Betwise.Accounts.Permissions
  use BetwiseWeb, :live_view

  alias Betwise.Games
  alias Betwise.Games.Game

  @impl true
  def mount(_params, _session, socket) do
    socket =
      if Permissions.user_has_permission?(
           socket.assigns.current_user,
           required_permission(socket.assigns.live_action)
         ) do
        socket
      else
        socket
        |> put_flash(:error, "Could not find the user")
        |> push_patch(to: socket.assigns.patch)
      end

    {:ok, stream(socket, :games, Games.list_games())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Game")
    |> assign(:game, Games.get_game!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Game")
    |> assign(:game, %Game{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Games")
    |> assign(:game, nil)
  end

  @impl true
  def handle_info({BetwiseWeb.SportsLive.Games.FormComponent, {:saved, game}}, socket) do
    {:noreply, stream_insert(socket, :games, game)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    game = Games.get_game!(id)
    {:ok, _} = Games.delete_game(game)

    {:noreply, stream_delete(socket, :games, game)}
  end

  defp required_permission(action) do
    list = [
      index: {"games", "read"},
      new: {"games", "create"},
      show: {"games", "read"},
      delete: {"games", "delete"}
    ]

    result = Enum.find(list, fn {key, _value} -> key == action end)

    case result do
      {_key, value} ->
        value

      nil ->
        IO.puts("Permission not found")
    end
  end
end
