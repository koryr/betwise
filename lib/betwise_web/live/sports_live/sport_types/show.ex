defmodule BetwiseWeb.SportsLive.SportTypes.Show do
  use BetwiseWeb, :live_view

  alias Betwise.Sports

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:sport_type, Sports.get_sport_type!(id))}
  end

  defp page_title(:show), do: "Show Sport type"
  defp page_title(:edit), do: "Edit Sport type"
end
