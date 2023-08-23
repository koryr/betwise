defmodule BetwiseWeb.Sports.SportTypeLive.Index do
  use BetwiseWeb, :live_view

  alias Betwise.Sports
  alias Betwise.Sports.SportType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :sport_type_collection, Sports.list_sport_type())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Sport type")
    |> assign(:sport_type, Sports.get_sport_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Sport type")
    |> assign(:sport_type, %SportType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Sport type")
    |> assign(:sport_type, nil)
  end

  @impl true
  def handle_info({BetwiseWeb.Sports.SportTypeLive.FormComponent, {:saved, sport_type}}, socket) do
    {:noreply, stream_insert(socket, :sport_type_collection, sport_type)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    sport_type = Sports.get_sport_type!(id)
    {:ok, _} = Sports.delete_sport_type(sport_type)

    {:noreply, stream_delete(socket, :sport_type_collection, sport_type)}
  end
end
