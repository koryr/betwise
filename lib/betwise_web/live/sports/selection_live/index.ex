defmodule BetwiseWeb.Sports.SelectionLive.Index do
  use BetwiseWeb, :live_view

  alias Betwise.Selections
  alias Betwise.Selections.Selection

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :selections, Selections.list_selections())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Selection")
    |> assign(:selection, Selections.get_selection!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Selection")
    |> assign(:selection, %Selection{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Selections")
    |> assign(:selection, nil)
  end

  @impl true
  def handle_info({BetwiseWeb.Sports.SelectionLive.FormComponent, {:saved, selection}}, socket) do
    {:noreply, stream_insert(socket, :selections, selection)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    selection = Selections.get_selection!(id)
    {:ok, _} = Selections.delete_selection(selection)

    {:noreply, stream_delete(socket, :selections, selection)}
  end
end
