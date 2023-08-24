defmodule BetwiseWeb.Sports.GameLive.AddOddsComponent do
  alias Betwise.BetTypes
  use BetwiseWeb, :live_component

  alias Betwise.Markets
  alias Betwise.BetTypes
  alias Betwise.Selections

  def mount(socket) do
    {:ok, assign(socket, :open, false)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <button
        type="button"
        phx-target={@myself}
        phx-click="add-odds"
        class="focus:outline-none text-sm  rounded-full py-1.5 px-4 font-semibold  hover:bg-gray-800
      hover:text-white dark:bg-gray-700"
      >
        <span class="btn">Add Odds</span>
      </button>

      <div style={if @open, do: "display:block", else: "display:none"}>
        <div class="flex mb-4">
          <.simple_form for={@form}>
          <div class="w-1/2">
            <.input
              field={@form[:bet_type_id]}
              phx-target={@myself}
              type="select"
              options={Enum.map(@bet_types, fn type -> {type.bet_type_name, type.id} end)}
              phx-change="onchange-bet-type"
              label="Bet Type"
            />
            </div>
            <div class="w-1/2">
            <%= Enum.map(@selections, fn selection -> %>
             <%= selection.name%>

            <%  end) %>
            </div>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def update(%{market: market} = assigns, socket) do
    changeset = Markets.change_market(market)
    bet_types = BetTypes.list_bet_types()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:bet_types, bet_types)
     |> assign(:selections, [])
     |> assign(:form, to_form(changeset))}
  end

  def handle_event("add-odds", _params, socket) do
    {:noreply, assign(socket, :open, !socket.assigns.open)}
  end

  def handle_event(
        "onchange-bet-type",
        %{"market" => %{"bet_type_id" => bet_type_id}},
        socket
      ) do
    selection = Selections.get_selections_by_bet_type!(bet_type_id)

    IO.inspect(selection)
    {:noreply, socket |> assign(:selections, selection)}
  end
end
