defmodule BetwiseWeb.SportsLive.Config do
  use BetwiseWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
