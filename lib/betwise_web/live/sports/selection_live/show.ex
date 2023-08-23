defmodule BetwiseWeb.Sports.SelectionLive.Show do
  use BetwiseWeb, :live_view

  alias Betwise.Selections

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:selection, Selections.get_selection!(id))}
  end

  defp page_title(:show), do: "Show Selection"
  defp page_title(:edit), do: "Edit Selection"
end
